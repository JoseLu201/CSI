
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris

irisDB = load_iris()

#Obtener las caracter´ısticas (datos de entrada X) y la clase (y).
X = irisDB.data
Y = irisDB.target

#Cuando nos pide que obtengamos las caracteristicas 1 y 3 
#Depende de si empezamos en 0
#data = X[:,[1,3]]
data = X[:,[0,2]]

#Separa los datos en los tres tipos
setosa = data[0:int(Y.size/3 -1)]
versicolor = data[int(Y.size/3):int(2*Y.size/3 -1)]
virginica = data[int(2*Y.size/3):int(Y.size)]

#Pintamos cada tipo de un color diferente
plt.scatter(setosa[:,0:1],setosa[:,1:2],c='r', label='setosa')
plt.scatter(versicolor[:,0:1],versicolor[:,1:2],c='g',label='versicolor')
plt.scatter(virginica[:,0:1],virginica[:,1:2],c='b',label='virginica')

plt.xlabel('sepal width (cm)')
plt.ylabel('petal width (cm)')
#Posicion de la leyenda
plt.legend(bbox_to_anchor=(1.04,0.5), loc="center left", borderaxespad=0)
plt.show()



