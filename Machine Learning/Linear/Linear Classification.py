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
from itertools import izip
%matplotlib inline

# <markdowncell>

# Setting things up

# <codecell>

size = 20

# number
n = 400*2

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
                   izip(outputs, self.Ys)
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
percy.train(300)
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

# <markdowncell>

# #Multinomial Linear Classification
# What if we have more than one class? I'm not going to explain this, but I put in a lot of comments.

# <codecell>

m = 50
classes = 3 
N = classes*m
inputs = np.vstack((np.random.randn(m, 2)+[3, 2], np.random.randn(m, 2)+[2,-2], np.random.randn(m, 2)-[2,0]))
X = np.hstack((np.ones((N,1)), inputs))
Y = np.vstack((np.zeros((m,1)), np.ones((m,1)), 2*np.ones((m,1)))).ravel()

# <codecell>

class MultiClassifier(object):
    """Linear classifier for k classes""" 
    def __init__(self, k):
        self.k = k

    def train(self, X, Y, rate=2, iterations=100):
        w = np.zeros((self.k, X.ndim+1))         # initialize weight matrix at 0
        for i in range(0, iterations):           # For t in every iteration
            grad = np.zeros((self.k, X.ndim+1))  # initialize a 3x3 gradient
            for x, y in izip(X, Y):              # go through every input-output pair
                exps = np.exp(w.dot(x))          # e^(xw)
                likelihood = exps[y] / np.sum(exps)  # this the softmax function, a probability distribution
                # update the gradient of the probability grad_y := grad_y + x(1-P(y|x))  
                grad[y, :] += x - x*likelihood  
                # analogous to self.weights = self.weights + self.Ys[i]*self.Xs[i]
            w = w + rate*grad/float(N)           # update weights with gradient descent
        self.weights = w
        
    def classify(self, x):
        return np.argmax(self.weights.dot(x))
    
    def error(self, X, Y):
        # Calculate error
        errors = 0.0
        total = len(X)
        for x, y in izip(X, Y):
            if self.classify(x) != y:
                errors += 1
        return errors / total
    
classifier = MultiClassifier(3)
classifier.train(X, Y)

# <codecell>

from matplotlib.colors import ListedColormap

cmap = ListedColormap(['#FFAAAA', '#AAAAFF', '#AAFFAA'])

x_min, x_max = X[:, 1].min() - 0.5, X[:, 1].max() + 0.5
y_min, y_max = X[:, 2].min() - 0.5, X[:, 2].max() + 0.5
h = 0.02 # step
xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
X_mesh = np.c_[np.ones((xx.size, 1)), xx.ravel(), yy.ravel()]

cells = np.array([classifier.classify(X_mesh[i, :]) for i in range(0, xx.size)]).reshape(xx.shape)

plot.figure()
plot.pcolormesh(xx, yy, cells, cmap=cmap)
plot.axis([np.min(X[:, 1]), np.max(X[:, 1]), np.min(X[:, 2]), np.max(X[:, 2])])
plot.plot(X[2*m:, 1], X[2*m:, 2], 'go')
plot.plot(X[0:m-1, 1], X[0:m-1, 2], 'ro')
plot.plot(X[m:2*m-1, 1], X[m:2*m-1,   2], 'bo')
plot.title("Error Rate %f" % classifier.error(X, Y))

