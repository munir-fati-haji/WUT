import numpy as np
import matplotlib.pyplot as plt


class PlotXY:
    def __init__(self, xstep, xrange):
        self.xstep = xstep
        self.xrange = xrange

    def generate_data(self):
        self.x1 = np.arange(0, self.xrange, 0.1 * self.xstep)
        self.x2 = np.arange(0, self.xrange, self.xstep)
        self.y1 = np.sin(self.x1)
        self.y2 = np.cos(self.x2)

    def plot1(self, title):
        plt.plot(self.x1, self.y1, 'r', self.x2, self.y2, 'b')
        plt.xlabel("x")
        plt.ylabel("y")
        plt.title(title)
        plt.legend(["sin", "cosine"], loc="upper right")
        plt.show()

    def plot2(self):
        plt.subplot(2, 1, 1)
        plt.title('title')
        plt.plot(self.x1, self.y1, 'r--')
        plt.xlabel("x")
        plt.ylabel("y")
        plt.grid()
        plt.subplot(2, 1, 2)
        plt.title('title')
        plt.plot(self.x2, self.y2, 'b--')
        plt.xlabel("x")
        plt.ylabel("y")
        plt.grid()
        plt.show()


c = PlotXY(0.1, 20)
c.generate_data()
c.plot1('Plot Title here')
c.plot2()
