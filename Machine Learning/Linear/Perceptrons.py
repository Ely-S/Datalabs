# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <markdowncell>

# ## Making a Perceptron
# 
# From scratch for fun.

# <codecell>

import numpy as np
import numpy.random as rand
import matplotlib.pyplot as plot
%matplotlib inline

# <markdowncell>

# Setting things up

# <codecell>

size = 20

# number
n = 400

xspace = np.linspace(0, size);

def DecisionBoundary(x):
    return 2*x+1

# Target Function
def f(x, y):
    # if above line
    if DecisionBoundary(x) > y:
        return 1
    return -1

# Red is a point above the target function and blue is below
def blue(x,y):
    plot.plot(x, y, 'bo')

def red(x,y):
    plot.plot(x, y, 'ro')

#trainingset = nr.rand(n, n)*size*2
xs = rand.rand(n)*size*2
ys = rand.rand(n)*size*2
plot.plot(xs, ys,'bo')
plot.plot(xspace, DecisionBoundary(xspace),'black')

# <codecell>

def display():
    for i in xrange(n):
        y = ys[i]
        x = xs[i]
        if f(x, y) == 1:
            red(x, y)
        else:
            blue(x,y)
    plot.plot(xspace, DecisionBoundary(xspace),'black')
display()

output = map(lambda a: f(*a), zip(xs, ys))
trainingset = np.array(zip(xs, ys, output))

# <codecell>

class Perceptron(object):
    weights = np.ones(3)

    # of the form w1x1 + w2x2 +cw2b2 + b
    def hypothesis(self, x):
        #transpose necessary for higher d
        return np.sign(self.weights.transpose().dot(x))

    def __init__(self, trainingset):
        # Ys = outputs
        # Xs = inputs in the form (x1, x2, 1)
        self.Ys = trainingset[:, 2]
        self.Xs = np.array(map(lambda t: (t[0], t[1], 1), trainingset))        
        self.n = len(self.Xs)
        
    def linear_hypothesis(self):
        a = -self.weights[0]/self.weights[1];
        b = self.weights[2]/self.weights[1];
        return lambda x: a * x + b;

    def update(self, i):
        self.weights = self.weights + self.Ys[i]*self.Xs[i]
    
    def find_misclassified(self):
        # yield unclassified points forever
        while True:
            for i, x in enumerate(self.Xs):
                if self.hypothesis(x) != self.Ys[i]:
                    yield i

    def error(self):
        # In Sample Error (Ein) = Correctly misclassified / Total
        outputs = map(self.hypothesis, self.Xs)
        mistakes = map(lambda a: a[0] == a[1],
                   zip(outputs, self.Ys)
                   ).count(False)
        return float(mistakes)/self.n
        
    def train(self, iterations=100):
        errors = self.find_misclassified()
        for i in xrange(iterations):
            self.update(errors.next())
        return self.weights

# <codecell>

percy = Perceptron(trainingset)
percy.train(50)
g = percy.linear_hypothesis()
plot.plot(xspace, g(xspace), 'blue')
display()
percy.error()

# <codecell>

percy = Perceptron(trainingset)
percy.train(200)
g = percy.linear_hypothesis()
plot.plot(xspace, g(xspace), 'blue')
display()
percy.error()

# <codecell>

percy = Perceptron(trainingset)
percy.train(1000)
g = percy.linear_hypothesis()
plot.plot(xspace, g(xspace), 'blue')
display()
percy.error()

# <markdowncell>

# ###Lets see how the error decreases with the number of iterations

# <codecell>

percy = Perceptron(trainingset)
for i in xrange(100):
    percy.train(10)
    plot.plot(i*10, percy.error(), "bo")
percy.error()

# <markdowncell>

# Lets add noise to the dataset!

# <codecell>

def noise(num):
    return num + rand.randint(-5,5)

def show(trainingset):
    for t in trainingset:
        if t[2] == 1: red(t[0], t[1])
        else: blue(t[0], t[1])
    plot.plot(xspace, DecisionBoundary(xspace),'black')

noisytrainingset = np.array(zip(map(noise, xs), map(noise, ys), output))
show(noisytrainingset)

# <codecell>

class PocketPerceptron(Perceptron):

    def train(self, iterations=100):
        mis = self.find_misclassified()
        best = self.error()
        bestweights = self.weights
        for i in xrange(iterations):
            self.update(mis.next())
            error = self.error()
            if error < best:
                best, bestweights = error, self.weights
            if  best == 0:
                print "Done!"
                break
        self.weights = bestweights
        return self.weights
    

# <codecell>

pocket = PocketPerceptron(noisytrainingset)
pocket.train(300)
g = pocket.linear_hypothesis()
plot.plot(xspace, g(xspace), 'blue')
show(noisytrainingset)
pocket.error()

# <codecell>

pocket = PocketPerceptron(trainingset)
for i in xrange(100):
    pocket.train(10)
    plot.plot(i*10, pocket.error(), "bo")
pocket.error()

# <codecell>


# <codecell>


