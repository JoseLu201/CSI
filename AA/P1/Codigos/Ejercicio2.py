# -*- coding: utf-8 -*-
"""
Created on Wed Mar 30 22:22:58 2022

@author: JoseL
"""
import numpy as np
import matplotlib.pyplot as plt
import time

np.random.seed(1)

label5 = 1
label1 = -1

# Funcion para leer los datos
def readData(file_x, file_y):
	# Leemos los ficheros	
	datax = np.load(file_x)
	datay = np.load(file_y)
	y = []
	x = []	
	# Solo guardamos los datos cuya clase sea la 1 o la 5
	for i in range(0,datay.size):
		if datay[i] == 5 or datay[i] == 1:
			if datay[i] == 5:
				y.append(label5)
			else:
				y.append(label1)
			x.append(np.array([1, datax[i][0], datax[i][1]]))
			
	x = np.array(x, np.float64)
	y = np.array(y, np.float64)
	
	return x, y

# Funcion para calcular el error cuadratico medio
def Err(x,y,w):
    #Error cuadratico medio
    # (1/n)*(x*w-y)^2
    h = x.dot(w)-y
    ans = np.power(h,2)
    return ans.mean()

'''
Sabemos que X es un vector (matrix) que tiene una 3-tupla, en la cual 
    La primera componente es siempre 1
    La segunda componente es la cantidad de ilumincaion
    La tercera componente es la cantidad de simatria
    
W es un vector de 3 posiciones 
'''
#El minibatch son los indices de las posiciones a elegir
#Este es el gradiente para el caso de SGD
def gradient(x,y,w,mini_batch):
    suma = 0
    for i in mini_batch:
        suma += x[i] * (np.sum(w*x[i])-y[i])
    return (suma*2/len(mini_batch))

# Gradiente Descendente Estocastico
#Necesitare X -> datos de entrada
#           y -> estiquetas del output deseado
#  

def sgd(x,y,eta,batch_size,maxIter,w,error2get):
    
    #print('X: ', x)
    #CReo indices aleatiors del tamaño de la muestra
    indices = np.random.permutation(len(x))
    #print('Shuffling index ', indices)
    min_batch_n = 0
    iterations = 0
    max_iter_batch = batch_size
    
    while(Err(x, y, w) > error2get and iterations < maxIter):
        #Si el tamaño maximo del mini_batch es mayor que el de la muestra
        # Comprobar que no cogemos todo la muestra
        if( max_iter_batch >= len(x) and (min_batch_n + batch_size ) < len(x) ):
            max_iter_batch = len(x)
        
        mini_batch = indices[min_batch_n : max_iter_batch]
            
        w = w - (eta * gradient(x,y,w,mini_batch))
    
        max_iter_batch += batch_size
        min_batch_n +=batch_size
    
        #Si me salgo de la muestra vuelvo al inicio, como un vector circular
        if(min_batch_n > len(x)):
            min_batch_n = 0
            max_iter_batch = batch_size
        iterations+=1
    return w



def simula_unif(N, d, size):
	return np.random.uniform(-size,size,(N,d))

def sign(x):
	if x >= 0:
		return 1
	return -1

def f(x1, x2):
	return sign((x1-0.2)**2+x2**2-0.6) 


def add_labels(data_set,fun):
    new_y = []
    for sa in data_set:
        if(fun(sa[0],sa[1]) >0):
            new_y.append(1)
        else:
            new_y.append(-1)   
    new_y = np.array(new_y, np.float64)        
    return new_y


#Añade a un conjunto de etiquetas un 'percent' de datos en forma de ruido
def add_noise(data_set,percent=0.1):
    #Creo el porcentaje de indices a cambiar
    rand = np.random.permutation(len(data_set))
    rand = rand[:int(percent*len(data_set))]
    for r in rand:
        data_set[r] *=-1
    return data_set



N = 1000
size = 1 
d = 2
w = np.zeros(3)
w[0] = 1

data_set = simula_unif(N, d, size)

def plot_regresion(x,y,w,title,xlabel,ylabel,xlim,ylim):
    fig = plt.figure()
    ax= fig.add_subplot()
    ax.scatter(x[:,1],x[:,2],c=y)
    ax.plot([0,1],[-w[0]/w[2], -w[0]/w[2] - w[1]/w[2]],color='red')
    plt.title(title)

    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    plt.xlim(xlim)
    plt.ylim(ylim)


'''

eta = 0.1
batch_size = 32
maxIter = 15
error2get = 1e-10
mean_err_in = []
mean_err_out = []
start_time = time.time()
for exp in range(1000):
    data_set_n = simula_unif(N, d, size)
    
    #test_data_set_n = simula_unif(N, d, size)
    #test_y_n = add_labels(test_data_set_n, f)
    #test_y_n = add_noise(test_y_n,0.1)
    
    y_n = add_labels(data_set_n,f)
    y_n = add_noise(y_n,0.1)

    data_set_n = np.insert(data_set_n,0,np.ones(len(data_set)),axis=1)
    #test_data_set_n = np.insert(test_data_set_n,0,np.ones(len(data_set)),axis=1)
    
    w_n = sgd(data_set_n, y_n, eta, batch_size, maxIter, w, error2get)
    mean_err_in.append(Err(data_set_n,y_n,w_n))
    #mean_err_out.append(Err(test_data_set_n, test_y_n, w_n))
    #print(exp)
    if(exp == 99):
        plot_regresion(data_set_n, y_n, w_n, 'Regresion_nn', '', '')
    

mean_err_in = np.array(mean_err_in, np.float64)
mean_err_out = np.array(mean_err_out, np.float64)
print ('Bondad del resultado el conjunto de datos tras 1000 ejecuciones:\n')
print ("Ein: ",mean_err_in.mean())
#print ("Eout: ",mean_err_out.mean())
print('Ha tardado ' , int(time.time() - start_time), ' segundos')

'''
#------------------------------



def vectorFeatures(x1,x2):
    vec_features = np.zeros((x1.size,6))
    vec_features[:,0] = 1
    vec_features[:,1] = x1
    vec_features[:,2] = x2
    vec_features[:,3] = x1*x2
    vec_features[:,4] = np.power(x1,2)
    vec_features[:,5] = np.power(x2,2)
    return vec_features


def gradient2(x,y,w):
    suma = np.sum(x.dot(w))-y
    return ( suma.dot(x) *2/x[:,0].size)

# Gradiente Descendente Estocastico
#Necesitare X -> datos de entrada
#           y -> estiquetas del output deseado
#  

def sgd2(x,y,eta,batch_size,maxIter,w,error2get):
    
    
    #CReo indices aleatiors del tamaño de la muestra
    indices = np.random.permutation(len(x))
    #https://stackoverflow.com/questions/47742622/np-random-permutation-with-seed
    #print('Shuffling index ', indices)
    min_batch_n = 0
    iterations = 0
    max_iter_batch = batch_size
    
    error = []
    
    while(Err(x, y, w) > error2get and iterations < maxIter):
        error.append(Err(x,y,w))
        #Si el tamaño maximo del mini_batch es mayor que el de la muestra
        # Comprobar que no cogemos todo la muestra
        if( max_iter_batch >= len(x) and (min_batch_n + batch_size ) < len(x) ):
            max_iter_batch = len(x)
        
        mini_batch_x1 = x[indices[min_batch_n : max_iter_batch]]
        mini_batch_x2 = y[indices[min_batch_n : max_iter_batch]]   
        
        w = w - (eta * gradient2(mini_batch_x1,mini_batch_x2,w))
    
        max_iter_batch += batch_size
        min_batch_n +=batch_size
    
        #Si me salgo de la muestra vuelvo al inicio, como un vector circular
        if(min_batch_n > len(x)):
            min_batch_n = 0
            max_iter_batch = batch_size
        iterations+=1
    error = np.array(error, np.float64)
    return w,iterations,error

w = np.zeros(6)
data_set = simula_unif(1000, 2, 1)
y_n = add_labels(data_set,f)
data_set= np.insert(data_set,0,np.ones(len(data_set)),axis=1)
y_n = add_noise(y_n,0.1)
sample = vectorFeatures(data_set[:,1], data_set[:,2])






#print(np.shape(data_set),np.shape(sample),np.shape(sample_y),np.shape(w))


#print(np.shape(data_set),data_set)

'''
from itertools import cycle
cycol = cycle('bgrcmk')

fig = plt.figure()
ax_e1= fig.add_subplot()

eta = 0.01
maxIter = 2000
error2get = 1e-9

for batch in [12,16,32]:
    w = np.zeros(6)
    data_set = simula_unif(1000, 2, 1)
    y_n = add_labels(data_set,f)
    data_set= np.insert(data_set,0,np.ones(len(data_set)),axis=1)
    y_n = add_noise(y_n,0.1)
    sample = vectorFeatures(data_set[:,1], data_set[:,2]) 
    w,iterations_sgd,error = sgd2(sample, y_n, eta, batch, maxIter, w, error2get)    
    #Esta figura muestra como baja el error conforme aumenta el numero de iteraciones, hasta que llega un punto 
    #en el cual se estabiliza
    #Podemos ver que en algunas iteraciones aumenta mucho el error
    ax_e1.plot(np.linspace(0,iterations_sgd,len(error)),error,c=next(cycol),linewidth=1,
                label="batch_size = {}".format(batch))
    plt.xlabel('Iteraciones')
    plt.ylabel('Error')
    print('------------------------------------')
    print ('Bondad del resultado el conjunto de datos:\n')
    print ("Ein: ", Err(sample,y_n,w))
    print ("w : ", w)
    print('Iteraciones: ' , iterations_sgd)
    print('Batch_size = ', batch)
    print('------------------------------------\n')
    
plt.legend()
'''




# vamos a modificar plot_scatter para mostrar la curva de regresión no lineal
def non_linear_plot(X, y, w_s,title=None, xlabel=None, ylabel=None):
    
    fig = plt.figure()
    ax= fig.add_subplot()
    
    ax.scatter(X[:,1],X[:,2],c=y)
    
    X_min0, X_max0 = np.min(X[:,1]), np.max(X[:,1])
    X_min1, X_max1 = np.min(X[:,2]), np.max(X[:,2])
    x_t, y_t = np.meshgrid(np.linspace(X_min0-0.5, X_max0+0.5, 100),np.linspace(X_min1-0.5, X_max1+0.5, 100))

    f_t = w_s[0] + w_s[1]*x_t + w_s[2]*y_t + w_s[3]*x_t*y_t + w_s[4]*x_t*x_t + w_s[5]*y_t*y_t
    print(f_t)
    #f_t = vectorFeatures(x_t, y_t)
    ax.contour(x_t, y_t, f_t, [0])
    plt.xlim([-1,1])
    plt.ylim([-1,1])
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)


#Como hemos visto antes los mejores parametros para esta funcion son batch_size bajos

w = np.zeros(6)
data_set = simula_unif(1000, 2, 1)
y_n = add_labels(data_set,f)
data_set= np.insert(data_set,0,np.ones(len(data_set)),axis=1)
y_n = add_noise(y_n,0.1)
sample = vectorFeatures(data_set[:,1], data_set[:,2]) 

eta = 0.01
batch = 16

#w,iterations_sgd,error = sgd2(sample, y_n, eta, batch, maxIter, w, error2get)
#
#non_linear_plot(data_set, y_n, w,title="Non Linear", xlabel="r$x_1$", ylabel="r$x_2$")
'''
fig = plt.figure()
ax= fig.add_subplot()
print(np.shape(w),w)
ax.scatter(data_set[:,0],data_set[:,1],c=y_n)
#ax.plot([0,1],[-w[0]/w[2], -w[0]/w[2] - w[1]/w[2]],color='red')
plt.title("Dne")



print ('Bondad del resultado el conjunto de datos:\n')
print ("Ein: ", Err(sample,y_n,w))
print ("w : ", w)
print('Iteraciones: ' , iterations_sgd)



'''


eta = 0.01
batch_size = 16
maxIter = 2000 
error2get = 1e-8
mean_err_in = []
mean_err_out = []
start_time = time.time()
size = 50
for exp in range(size):
    w = np.zeros(6)
    data_set_n = simula_unif(N, d, size)
    
    y_n = add_labels(data_set_n,f)
    data_set_n= np.insert(data_set_n,0,np.ones(len(data_set_n)),axis=1)
    y_n = add_noise(y_n,0.1)
    sample = vectorFeatures(data_set_n[:,1], data_set_n[:,2]) 
    
    w_n,iterations_sgd,error = sgd2(sample, y_n, eta, batch, maxIter, w, error2get)
    mean_err_in.append(Err(sample,y_n,w_n))
    #mean_err_out.append(Err(test_data_set_n, test_y_n, w_n))
    #print(exp)
    i =0
    if(100*i == exp):
        print(exp)
        i+=1
    

mean_err_in = np.array(mean_err_in, np.float64)
mean_err_out = np.array(mean_err_out, np.float64)
print ('Bondad del resultado el conjunto de datos tras 1000 ejecuciones:\n')
print ("Ein: ",mean_err_in.mean())
#print ("Eout: ",mean_err_out.mean())
print('Ha tardado ' , int(time.time() - start_time), ' segundos')





