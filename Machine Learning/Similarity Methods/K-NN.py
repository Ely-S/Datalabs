# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <markdowncell>

# #Problem 1
# 
# 1. With the following dataset show the decision regions ofr the 1-NN and 3-NN rules
# 2. Then do the same with the following non-linear transforms
# 
# 
#     z1 = sqrt(x1^2 + x2^2)
#     z2 = arctan(x2/x1)

# <codecell>

from numpy import array

data  = {
    "data": array([[1, 0], [0, 1], [0, -1], [-1, 0], [0, 2], [0, -2], [-2, 0]]),
    "target": array([-1, -1, -1, -1, 1, 1, 1])
}

# <codecell>

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from sklearn import neighbors
%matplotlib inline

# <codecell>

cmap_light = ListedColormap(['#FFAAAA', '#AAFFAA', '#AAAAFF'])
cmap_bold = ListedColormap(['#FF0000', '#00FF00', '#0000FF'])

h = .02  # step size in the mesh

for k in (1, 3):
    clf = neighbors.KNeighborsClassifier(k)
    
    clf.fit(data['data'], data['target'])
    
    x_min, x_max = data['data'][:, 0].min() - 1, data['data'][:, 0].max() + 1
    y_min, y_max = data['data'][:, 1].min() - 1, data['data'][:, 1].max() + 1
    xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
    Z = clf.predict(np.c_[xx.ravel(), yy.ravel()])
    
    Z = Z.reshape(xx.shape)
    plt.figure()
    plt.pcolormesh(xx, yy, Z, cmap=cmap_light)
    
    plt.scatter(data['data'][:, 0], data['data'][:, 1], c=data['target'], cmap=cmap_bold)
    plt.xlim(xx.min(), xx.max())
    plt.ylim(yy.min(), yy.max())

# <codecell>

def transform(X):
    z = X[:]
    z[0] = np.sqrt(np.square(X[0]) + np.square(X[1]))
    z[1] = np.arctan(X[1]/ X[0])
    return z

for k in (1, 3):
    
    X = transform(data['data'])
    
    clf = neighbors.KNeighborsClassifier(k)
    
    clf.fit(X, data['target'])
    
    x_min, x_max = X[:, 0].min() - 1, X[:, 0].max() + 1
    y_min, y_max = X[:, 1].min() - 1, X[:, 1].max() + 1
    xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
    Z = clf.predict(np.c_[xx.ravel(), yy.ravel()])
    
    Z = Z.reshape(xx.shape)
    plt.figure()
    plt.pcolormesh(xx, yy, Z, cmap=cmap_light)
    
    plt.scatter(X[:, 0], X[:, 1], c=data['target'], cmap=cmap_bold)
    plt.xlim(xx.min(), xx.max())
    plt.ylim(yy.min(), yy.max())

# <markdowncell>

# #Problem 2
# 
# (a) Let the mean of all the -1 points be μ −1 and the mean of all the +1 points
# be μ +1 . Suppose the data set were condensed into the two prototypes
# {(μ −1 , −1), (μ +1 , +1)} (these points need not be data points, so they
# are called prototypes).
# 
# Plot the classification regions for the 1-NN rule using the condensed data.

# <codecell>

# from inspection of data, all negative 1s are the first 4
pos = data['data'][4:]
neg = data['data'][:4]
upos = array([pos[:,0].mean(), pos[:,1].mean()])
uneg = array([neg[:,0].mean(), neg[:,1].mean()])

# <codecell>

clf = neighbors.KNeighborsClassifier(1)

X = array([upos, uneg])
Y = array([1, -1])
clf.fit(X, Y)

x_min, x_max = X[:, 0].min() - 1, X[:, 0].max() + 1
y_min, y_max = X[:, 1].min() - 1, X[:, 1].max() + 1
xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
Z = clf.predict(np.c_[xx.ravel(), yy.ravel()])

Z = Z.reshape(xx.shape)
plt.figure()
plt.pcolormesh(xx, yy, Z, cmap=cmap_light)
plt.scatter(X[:, 0], X[:, 1], c=Y, cmap=cmap_bold)
silent = plt.xlim(xx.min(), xx.max()) # to silence the output

# <markdowncell>

# What is the in-sample error?

# <codecell>

predictions = clf.predict(data['data'])
diff = (predictions - data['target'])!=0
errors = diff.tolist().count(True)
print  "In Sample Error: %f" % (errors / float(len(data['data'])))

# <markdowncell>

# (b) Consider the following approach to condensing the data. At each step,
# merge the two closest points of the same class as follows:
# 
#     (x, c) + (x′, c) → (2/1 (x + x′), c).
# 
# Again, this method of condensing produces prototypes. Continue condensing until you have two points remaining (of different classes).
# 
# Plot the 1-NN rule with the condensed data.

# <codecell>

pos = data['data'][4:]
neg = data['data'][:4]
condensor = lambda x1, x2: array([(x1[0]+x2[0])/2 , x1[1]])
uneg = reduce(condensor, neg)
upos = reduce(condensor, pos)
X = array([upos, uneg])
Y = array([1, -1])
clf.fit(X, Y)

x_min, x_max = X[:, 0].min() - 1, X[:, 0].max() + 1
y_min, y_max = X[:, 1].min() - 1, X[:, 1].max() + 1
xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
Z = clf.predict(np.c_[xx.ravel(), yy.ravel()])

Z = Z.reshape(xx.shape)
plt.figure()
plt.pcolormesh(xx, yy, Z, cmap=cmap_light)
plt.scatter(X[:, 0], X[:, 1], c=Y, cmap=cmap_bold)
silent = plt.xlim(xx.min(), xx.max()) # to silence the output

# <markdowncell>

#  What is the in-sample error?

# <codecell>

predictions = clf.predict(data['data'])
diff = (predictions - data['target'])!=0
errors = diff.tolist().count(True)
print  "In Sample Error: %f" % (errors / float(len(data['data'])))

