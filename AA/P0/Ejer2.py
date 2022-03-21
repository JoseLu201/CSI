import numpy as np
from sklearn.datasets import load_iris

# 80% de 150 = 120
# Por lo que necesito muestas de 50 cada vez

irisDB = load_iris()
X = irisDB.data
y = irisDB.target

#Funcion que nos perimte realizar el ejercicio, como parametros vamos a necesitar los datos
#el tamaño del test y una semilla por si queremos repetir la aleatoriead 
def my_train_test_split(X,y,test_size=0.2,rand_state=10):
    
    #Concateno tanto la X como la y para que cuando randomize no se pierda la relacion
    concatenada = np.concatenate((X,y.reshape(len(y),1)),axis=1)
    #Dividimos en los tres tipos
    setosa = concatenada[0:int((len(X)/3))]
    ver =  concatenada[int(len(X)/3):int((2/3 * len(X)))]
    virgi =  concatenada[int(2/3 * len(X)) : len(X) ]

    #Aleatorizamos 
    np.random.seed(rand_state)
    rand_setosa = np.random.permutation(setosa)
    rand_ver = np.random.permutation(ver)
    rand_virgi = np.random.permutation(virgi)
       

    #Creamos el training cogiendo el numero de elementos que deseemos (test_size) 
    train = np.concatenate((rand_setosa[0:int(len(rand_setosa)*(1-test_size))],rand_ver[0:int(len(rand_ver)*(1-test_size))],rand_virgi[0:int(len(rand_virgi)*(1-test_size))] ),axis=0)
    #Randomizamos los casos de entrenamiento
    rand_train = np.random.permutation(train)
    #Separamos las caracteristicas
    X_train = rand_train[:,[0,1,2,3]]
    y_train = rand_train[:,[4]]
    
    #Igual con test
    test = np.concatenate((rand_setosa[0:int(len(rand_setosa)*(test_size))],rand_ver[0:int(len(rand_ver)*(test_size))],rand_virgi[0:int(len(rand_virgi)*(test_size))] ),axis=0)
    rand_test = np.random.permutation(test)
    
    X_test = rand_test[:,[0,1,2,3]]
    y_test = rand_test[:,[4]]

    #Convertimos esto a un array
    y_train, = np.asarray(y_train.T)
    y_test, = np.asarray(y_test.T)
    return X_train, X_test, y_train, y_test

    
X_train,X_test,y_train,y_test = my_train_test_split(X,y,test_size=0.2)

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

