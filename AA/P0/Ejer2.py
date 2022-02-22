from cmath import sin
import math 
import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split


irisDB = load_iris()

#Obtener las caracter´ısticas (datos de entrada X) y la clase (y).
X = irisDB.data
Y = irisDB.target

x_train, x_test, y_train, y_test = train_test_split(X, Y,test_size=0.33)
print(y_test,y_test.__len__)