import numpy as np
import matplotlib.pyplot as plt
import pickle

class neuron_fcn(object):
    def output(self, neuron, derivative=False):
        """Dispatch method"""
        # Get the method from 'self'. Default to a lambda.
        name = neuron['activation_function']
        method = getattr(self, str(name), "Invalid_function")
        # Call the method as we return it
        return method(neuron, derivative)

    def Invalid_function(self, *arg):
        print("Error: Invalid activation function")
        return None

    def activation_potential(self, neuron, inputs):
        activation = 0
        if neuron["bias"]:
            inputs = np.append(inputs, 1)
        for i, weight in enumerate(neuron["weights"]):
            activation += weight * inputs[i]
        return activation

    def linear(self, neuron, derivative=False):
        out = 0
        if not derivative:
            out = neuron['activation_potential']
        else:
            out = 1
        return out

    def logistic(self, neuron, derivative=False):
        out = 0
        if not derivative:
            out = 1.0 / (1.0 + np.exp(-neuron['activation_potential']))
        else:
            out = neuron['output'] * (1.0 - neuron['output'])
        return out

    def tanh(self, neuron, derivative=False):
        out = 0
        if not derivative:
            out = (np.exp(neuron['activation_potential']) - np.exp(-neuron['activation_potential'])) / (
                    np.exp(neuron['activation_potential']) + np.exp(-neuron['activation_potential']))
        else:
            out = 1.0 - np.power(neuron['output'], 2)
        return out

    def relu(self, neuron, derivative=False):
        out = 0
        if not derivative:
            out = np.maximum(0, neuron['activation_potential'])
        else:
            if neuron['activation_potential'] >= 0:
                out = 1
        return out

class loss_fcn(object):
    # Error value of neuron
    def loss(self, loss, expected, outputs, derivative):
        """Dispatch method"""
        # Get the method from 'self'. Default to a lambda.
        method = getattr(self, str(loss), lambda: "Invalid_function")
        # Call the method as we return it
        return method(expected, outputs, derivative)

    def sum(self, loss, expected, outputs, derivative):
        """Dispatch method"""
        # Get the method from 'self'. Default to a lambda.
        method = getattr(self, str(loss), lambda: "Invalid loss function")
        # Call the method as we return it
        error_sum = 0
        for exp, out in zip(expected, outputs):
            error_sum += method(exp, out, derivative)
        return error_sum

    def Invalid_function(self, *arg):
        print("Error: Invalid loss function")
        return None

    # Mean Square Error loss function
    def mse(self, expected, outputs, derivative=False):
        error_value = 0
        if not derivative:
            error_value = 0.5 * (expected - outputs) ** 2
        else:
            error_value = -(expected - outputs)
        return error_value

    # Cross-entropy loss function
    def binary_cross_entropy(self, expected, outputs, derivative=False):
        error_value = 0
        if not derivative:
            error_value = -expected * np.log(outputs) - (1 - expected) * np.log(1 - outputs)
        else:
            error_value = -(expected / outputs - (1 - expected) / (1 - outputs))
        # print(f"output = {outputs}, expected = {expected}, error = {error_value}, derivative = {derivative}")
        return error_value


# Initialize a network
class Neural_network(object):
    def create_network(self, structure):
        self.nnetwork = list()
        for index, layer in enumerate(structure[1:], start=1):
            new_layer = []
            for i in range(layer['units']):
                neuron = {
                    'weights': [np.random.randn() for i in range(structure[index - 1]['units'] + int(layer['bias']))],
                    'bias': layer['bias'],
                    'activation_function': layer['activation_function'],
                    'activation_potential': 0,
                    'delta': [0 for i in range(structure[index - 1]['units'] + int(layer['bias']))],
                    'output': 0}
                new_layer.append(neuron)
            self.nnetwork.append(new_layer)
        return self.nnetwork

    # Forward propagate input to a network output
    def forward_propagate(self, nnetwork, inputs):
        row = list(inputs.copy())
        for layer in nnetwork:
            next_row = []
            for neuron in layer:
                bias_inputs = row.copy()
                if neuron['bias']:
                    bias_inputs.append(1)
                tf = neuron_fcn()
                neuron['activation_potential'] = tf.activation_potential(neuron, row)
                neuron['output'] = tf.output(neuron, derivative=False)
                next_row.append(neuron['output'])
            row = next_row.copy()
        return row

    # Backpropagate error and store it in neuron
    def backward_propagate(self, loss_function, nnetwork, expected):
        for i in reversed(range(len(nnetwork))):
            layer = nnetwork[i]
            errors = list()
            if i != len(nnetwork) - 1:
                for j in range(len(layer)):
                    error = 0.0
                    for neuron in nnetwork[i + 1]:
                        error += (neuron['weights'][j] * neuron['delta'])
                    errors.append(error)
            else:
                for j in range(len(layer)):
                    neuron = layer[j]
                    loss = loss_fcn()
                    errors.append(loss.loss(loss_function, expected[j], neuron['output'], derivative=True))
            for j in range(len(layer)):
                tf = neuron_fcn()
                neuron = layer[j]
                neuron['delta'] = errors[j] * tf.output(neuron, derivative=True)

    # Update network weights with error
    def update_weights(self, nnetwork, inputs, l_rate):
        for i in range(len(nnetwork)):
            row = inputs
            if i != 0:
                row = [neuron['output'] for neuron in nnetwork[i - 1]]

            for neuron in nnetwork[i]:
                for j in range(len(row)):
                    neuron['weights'][j] -= l_rate * neuron['delta'] * row[j]
                if neuron['bias']:
                    neuron['weights'][-1] -= l_rate * neuron['delta']

    # Train a network for a fixed number of epochs
    #Task starts here
    def train(self, nnetwork, x_train, y_train, l_rate=0.001, n_epoch=100, loss_function='mse', verbose=1,accuracy=0.01,patience=5):
        
        epoch_loss=[]
        iteration_loss=[]
        patiencecount=0
        bestnetwork=nnetwork
        
        for i,epoch in enumerate(range(n_epoch)):
            sum_error = 0
            
            each_iteration_loss=[]

            for iter, (x_row, y_row) in enumerate(zip(x_train, y_train)):
                
                if not len(np.shape(x_row)): 
                    x_row = [x_row]
                if not len(np.shape(y_row)):
                    y_row = [y_row]

                outputs = self.forward_propagate(nnetwork, x_row)

                loss = loss_fcn()
                
                l = loss.sum(loss_function, y_row, outputs, derivative=False)
                each_iteration_loss.append(l)
                sum_error += l
                if verbose > 1:
                    print(f"iteration = {iter + 1}, output = {outputs}, target = {y_row}, loss = {l:.4f}")

                self.backward_propagate(loss_function, nnetwork, y_row)
                
                self.update_weights(nnetwork, x_row, l_rate)
            iteration_loss.append(each_iteration_loss)
            epoch_loss.append(sum_error)
            last_sum_error=0
            # To find difference in total lose we at least need two values
            if i<2:
                last_sum_error=0
            elif i>=2:
                last_sum_error=epoch_loss[-2]
                
            #To visual the if the patience count function is working 
            formated_last_sum_error=float(format(last_sum_error, ".3f"))
            formated_sum_error=float(format(sum_error, ".3f"))
            
            #compare models to return the best model by comparing loss
            nnetworkscompared=[]
            loss_compared=[]

            if formated_last_sum_error==formated_sum_error:
                patiencecount+=1
                nnetworkscompared.append(nnetwork)
                loss_compared.append(sum_error)
            else:
                patiencecount=0
                nnetworkscompared=[]
                loss_compared=[]
            
            epoch_accuracy=sum_error-last_sum_error
            
            if epoch_accuracy<accuracy and patiencecount==patience:
                print(f'epoch minimum accuracy of {accuracy} with patience of {patience} reached')
                best_loss=min(loss_compared)
                index_of_best_loss=loss_compared.index(best_loss)
                bestnetwork=nnetworkscompared[index_of_best_loss]
                break

            if verbose > 0:
                print('>epoch=%d, loss=%.3f' % (epoch + 1, sum_error))
        return bestnetwork,epoch_loss,iteration_loss

    # Calculate network output
    def predict(self, neuron, inputs):
        y = []
        for input in inputs:
            y.append(self.forward_propagate(neuron, input))
        return y


def generate_regression_data(n, tosave=True, fname="reg_data"):
     # Generate regression dataset
    X = np.linspace(-5, 5, n).reshape(-1, 1)
    data_noise = np.random.normal(0, 0.2, n).reshape(-1, 1)
    xaxis = np.sin(2 * X)
    yaxis = np.cos(X)
    x1, x2 = np.meshgrid(xaxis, yaxis)
    y = x1 * x2 + data_noise + 7

    fig=plt.figure()
    ax=fig.add_subplot(projection='3d')
    ax.scatter(x1,x2,y,c="red", label="Predicted")
    plt.title('Generated regression dataset')
    plt.legend()
    plt.show()

    x1=np.reshape(x1, (x1.size))
    x2=np.reshape(x2, (x2.size))
    y=np.reshape(y, (1,-1))

    train_x = np.column_stack((x1,x2))
    train_y = np.column_stack((y))

    np.savetxt('x_data.dat', train_x)
    np.savetxt('y_data.dat', train_y)
    
    return train_x, train_y



def read_regression_data(fname="reg_data"):
    x = np.loadtxt('x_data.dat')
    y = np.loadtxt('y_data.dat')

    x1 = np.loadtxt('x_data.dat',usecols=(0,))
    x2 = np.loadtxt('x_data.dat',usecols=(1,))

    fig=plt.figure()
    ax=fig.add_subplot(projection='3d')
    ax.scatter(x1,x2,y,c="red", label="Training data")
    plt.title('Loaded regression dataset')
    plt.legend()
    plt.show()

    return x, y,x1,x2

def save_or_load(file,operation,model, tosave=True, fname="save model"):
    if operation=='save':
        with open(file, 'wb') as f:
            pickle.dump(model, f)
    elif operation=='load':
        try:
            with open(file, 'rb') as f:
                model = pickle.load(f)
        except:
            pass
    return model
def history_plot(epoch_loss,iteration_loss):
    epoch_range=np.arange(0, len(epoch_loss))
    iteration_loss=np.array(iteration_loss).T
    
    plt.figure()

    plt.subplot(1,2,1)
    plt.title("History Plot - Total Loss")
    plt.plot(epoch_range,epoch_loss,label="Total Loss")
    plt.xlabel("Epoch")
    plt.ylabel("Total Loss")
    plt.legend()
    plt.grid()

    plt.subplot(1,2,2)
    for i, iter in enumerate(iteration_loss, start=1):
        plt.plot(iter,label=f'iteration {i}')
    plt.xlabel("Epoch")
    plt.title("History Plot - Iteration Loss")
    plt.ylabel("Iteration Loss")
    plt.legend()
    plt.grid()

def test_regression():
    # Read data
    x_train, y_train, train_x1, train_x2= read_regression_data()

    # Create network
    model = Neural_network()
    structure = [{'type': 'input', 'units': 2},
                 {'type': 'dense', 'units': 8, 'activation_function': 'tanh', 'bias': True},
                 {'type': 'dense', 'units': 8, 'activation_function': 'tanh', 'bias': True},
                 {'type': 'dense', 'units': 1, 'activation_function': 'linear', 'bias': True}]

    network = model.create_network(structure)
    
    loaded_weight=[]
    loaded_network=save_or_load('model.dat','load',network)
    # Loop for updating the weight based on the saved model
    try:
        for layer in loaded_network:
            loaded_weight_layer=[]
            for neuron in layer:
                loaded_weight_layer.append(neuron['weights'])
            loaded_weight.append(loaded_weight_layer)

        for loadedlayer,layer in enumerate(network):
            for loadedneuron,neuron in enumerate(layer):
                neuron['weights']=loaded_weight[loadedlayer][loadedneuron]
    except:
        network = model.create_network(structure)
    
    network,epoch_loss,iteration_loss=model.train(network, x_train, y_train, 0.001, 10000, 'mse',1,0.01,5)
    
    history_plot(epoch_loss,iteration_loss)

    save_or_load('model.dat','save',network)
   
    X = np.linspace(-6, 6, 20).reshape(-1, 1)
    xaxis = np.sin(2 * X)
    yaxis = np.cos(X)
    x_test1, x_test2 = np.meshgrid(xaxis, yaxis)
    
    test_x1=np.reshape(x_test1, (x_test1.size))
    test_x2=np.reshape(x_test2, (x_test2.size))
    test_x = np.column_stack((test_x1,test_x2))
    
    predicted = model.predict(network, test_x)

    fig=plt.figure()
    ax=fig.add_subplot(projection='3d')
    ax.scatter(train_x1,train_x2,y_train,c="red", label="Training data")
    ax.scatter(test_x1,test_x2,predicted,c="blue", label="Predicted")
    plt.legend()
    plt.show()

generate_regression_data(20)
test_regression()