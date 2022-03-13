def stats_list(x):
    try:
        sum=0
        maximumValue=x[0]
        minimumValue=x[0]
        y=[]
        
        for i in x:
            sum+=i
        averageValue=sum/len(x)

        for i in x:
            if i>maximumValue:
                maximumValue=i

        for i in x:
            if i<minimumValue:
                minimumValue=i

        for i in x:
            y.append((i**0.5))
        
        print(f"The maximum value is {maximumValue}")
        print(f"The minimum value is {minimumValue}")
        print(f"The average value is {averageValue}")
        return y
    except:
        print("Wrong input")
    

x=[4,1,16,9,36,25,49]

a=stats_list(x)

print(a)