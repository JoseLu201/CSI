import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris

irisDB = load_iris()

#Obtener las caracter´ısticas (datos de entrada X) y la clase (y).
X = irisDB.data
Y = irisDB.target

#print(X,Y)
#print(irisDB.feature_names)
#print(irisDB.target_names)
#print(irisDB.DESCR)

#Cuando nos pide que obtengamos las caracteristicas 1 y 3 vemos que se trata de
#sepal width (cm) y petal width (cm)

data = X[:,[1,3]]
#data = X[:,[0,2]]
setosa = data[0:int(Y.size/3 -1)]
versicolor = data[int(Y.size/3):int(2*Y.size/3 -1)]
virginica = data[int(2*Y.size/3):int(Y.size)]

#print(setosa,versicolor,virginica)

plt.scatter(setosa[:,0:1],setosa[:,1:2],c='r', label='setosa')
plt.scatter(versicolor[:,0:1],versicolor[:,1:2],c='g',label='versicolor')
plt.scatter(virginica[:,0:1],virginica[:,1:2],c='b',label='virginica')

plt.xlabel('sepal width (cm)')
plt.ylabel('petal width (cm)')
plt.legend(bbox_to_anchor=(1.04,0.5), loc="center left", borderaxespad=0)
#plt.show()
plt.savefig('output.png')
