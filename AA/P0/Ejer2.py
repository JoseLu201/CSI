import numpy as np
from sklearn.datasets import load_iris

# 80% de 150 = 120
# Por lo que necesito muestas de 50 cada vez

irisDB = load_iris()
X = irisDB.data
y = irisDB.target


def my_train_test_split(X,y,test_size=0.2,rand_state=30):
  np.random.seed(rand_state)
  rand_X = np.random.permutation(X)
  rand_y = np.random.permutation(y)

  X_train = rand_X[0:int(len(rand_X)*(1-test_size))]
  X_test = rand_X[int(len(rand_X)*(1-test_size)):len(rand_X)]

  y_train = rand_y[0:int(len(rand_y)*(1-test_size))]
  y_test = rand_y[int(len(rand_y)*(1-test_size)):len(rand_y)]

  return X_train,X_test,y_train,y_test

X_train,X_test,y_train,y_test = my_train_test_split(X,y,test_size=0.2)

#print("Clase de los ejemplos de entrenamiento: " ,len(X_train),X_train)
#print(len(X_test),X_test)
print("--- Clase Setosa ---")
print("Ejemplos Train: " ,int(len(X)*0.8/3))
print("Ejemplos Test: " ,int(len(X)*0.2/3))
print("--- Clase Versicolor ---")
print("Ejemplos Train: " ,int(len(X)*0.8/3))
print("Ejemplos Test: " ,int(len(X)*0.2/3))
print("--- Clase Virgincia---")
print("Ejemplos Train: " ,int(len(X)*0.8/3))
print("Ejemplos Test: " ,int(len(X)*0.2/3))
print("Clase de los ejemplos de entrenamiento: ",len(y_train))
print(y_train)
print("Clase de los ejemplos de test: " ,len(y_test))
print(y_test)