# -*- coding: utf-8 -*-
"""
TRABAJO 1. 
Nombre Estudiante: Jose Luis Molin Aguilar
"""

import numpy as np
import matplotlib.pyplot as plt



np.random.seed(1)

print('EJERCICIO SOBRE LA BUSQUEDA ITERATIVA DE OPTIMOS\n')
print('Ejercicio 1\n')

#Definimos la funcion a evaluar
def E(u,v): 
    return np.power(u*v*np.exp(-u**2-v**2),2)

    
#Derivada parcial de E con respecto a u
def dEu(u,v):
    return -2*u*(2*u**2 -1)*v**2*np.exp(-2*(u**2+v**2))
    
#Derivada parcial de E con respecto a v
def dEv(u,v):
    return (-2*u**2*v*(2*v**2 -1)*np.exp(-2*(u**2+v**2)))

#Gradiente de E
def gradE(u,v):
    return np.array([dEu(u,v), dEv(u,v)])
'''
#Implementacion del gradiente descendiente.
#Parametros:
    w_ini = Como todavia no estamos en regresion lineal, representa las coordenadas iniciales
    lr = tasa de aprendizaje, valores entre (0.01 y 0.1)
    grad_f = gradiente de la funcion a evaluar
    fun = funcion a evaluar
    epsilon = maximo error en la evaluacion
    max_iters = numero maximo de iteraciones
#Devuelve
    w = coordenadas del punto en el que encontro el minimo(o el ultimo punto antes de parar)
    iterations= numero de iteraciones hasta parar
    ws = conjuto de todos los pasos que ha dado
'''
def gradient_descent(w_ini, lr, grad_fun, fun, epsilon, max_iters,only_iters=False):
    iterations = 0
    w = w_ini
    ws = np.matrix(w_ini)
    
        
    if(only_iters):
        while(iterations < max_iters):
            iterations+=1
            w = w - (lr * grad_fun(w[0], w[1]))
            ws = np.append(ws,[w],axis=0)
    else:
        while(fun(w[0],w[1]) > epsilon and iterations < max_iters):
            iterations+=1
            w = w - (lr * grad_fun(w[0], w[1]))
            ws = np.append(ws,[w],axis=0)
    return w, iterations,ws   


'''
Esta función muestra una figura 3D con la función a optimizar junto con el 
óptimo encontrado y la ruta seguida durante la optimización. Esta función, al igual
que las otras incluidas en este documento, sirven solamente como referencia y
apoyo a los estudiantes. No es obligatorio emplearlas, y pueden ser modificadas
como se prefiera. 
    rng_val: rango de valores a muestrear en np.linspace()
    fun: función a optimizar y mostrar
    ws: conjunto de pesos (pares de valores [x,y] que va recorriendo el optimizador
                           en su búsqueda iterativa del óptimo)
    colormap: mapa de color empleado en la visualización
    title_fig: título superior de la figura
    
Ejemplo de uso: display_figure(2, E, ws, 'plasma','Ejercicio 1.2). Función sobre la que se calcula el descenso de gradiente')
'''
#He modificado un poco la funcion para poder darle un nombre a la funcion, puedo ponerlo en 
#formato latex con r'funcion'
def display_figure(rng_val, fun, ws, colormap, title_fig,fun_name):
    # https://jakevdp.github.io/PythonDataScienceHandbook/04.12-three-dimensional-plotting.html
    from mpl_toolkits.mplot3d import Axes3D
    x = np.linspace(-rng_val, rng_val, 50)
    y = np.linspace(-rng_val, rng_val, 50)
    X, Y = np.meshgrid(x, y)
    Z = fun(X, Y) 
    fig = plt.figure()
    ax = Axes3D(fig,auto_add_to_figure=False)
    fig.add_axes(ax)
    ax.plot_surface(X, Y, Z, edgecolor='none', rstride=1,cstride=1, cmap=colormap, alpha=.6)
    if len(ws)>0:
        ws = np.asarray(ws)
        min_point = np.array([ws[-1,0],ws[-1,1]])
        min_point_ = min_point[:, np.newaxis]
        ax.plot(ws[:-1,0], ws[:-1,1], fun(ws[:-1,0], ws[:-1,1]), 'r*', markersize=5)
        ax.plot(min_point_[0], min_point_[1], fun(min_point_[0], min_point_[1]), 'r*', markersize=10)
    
        #np.set_printoptions(threshold=np.inf)
    if len(title_fig)>0:
        fig.suptitle(title_fig, fontsize=16)
    ax.set_xlabel('u')
    ax.set_ylabel('v')
    ax.set_zlabel(fun_name)

#--------------------------
def plot_regresion(x,y,w,title,xlabel,ylabel,xlim,ylim):
    fig = plt.figure()
    ax= fig.add_subplot()
    ax.scatter(x[:,1],x[:,2],c=y)
    #if(w != None):
    ax.plot([0,1],[-w[0]/w[2], -w[0]/w[2] - w[1]/w[2]],color='red')
    plt.title(title)

    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    plt.xlim(xlim)
    plt.ylim(ylim)

#input("\n--- Pulsar tecla para continuar ---\n")

#Variables de entrada
eta = 0.1
maxIter = 10000000000
error2get = 1e-8
initial_point = np.array([0.5,-0.5])

#Calculo gradiente sobre E
w, it, ws = gradient_descent(initial_point,eta,gradE,E,error2get,maxIter)

print ('Numero de iteraciones: ', it)
print ('Coordenadas obtenidas: (', w[0], ', ', w[1],')')

###display_figure(2, E, ws, 'plasma','Ejercicio 1.2.',r'E(u,v)')

#Plot para ver que hay muchas iteraciones en las que no he anvanzado mucho
'''
ws = np.asarray(ws)

fig = plt.figure()
ax_gra1= fig.add_subplot()

ax_gra1.plot(np.arange(it+1),E(ws[:,0],ws[:,1]))
plt.xlabel('Iteraciones')
plt.ylabel('Error2get')
plt.title('Error = $10^{-8}$')

#Repito el experimento pero con un error mucho menor
error2get = 1e-4
w, it, ws = gradient_descent(initial_point,eta,gradE,E,error2get,maxIter)

ws = np.asarray(ws)
fig = plt.figure()
ax_gra2= fig.add_subplot()

ax_gra2.plot(np.arange(it+1),E(ws[:,0],ws[:,1]),color='red',markersize=6)
plt.xlabel('Iteraciones')
plt.ylabel('Error2get')
plt.title('Error = $10^{-4}$')
'''

input("\n--- Pulsar tecla para continuar ---\n")



#------------------------------------------
#   Funciones para ejercicio 3
#------------------------------------------

#Definicion de funcion para el ejercicio 1.3
def f1(x,y):
    return np.power(x,2)+ 2*np.power(y,2) +2*np.sin(2*np.pi*x)*np.sin(np.pi*y)

#Derivada de f respecto de x
def dfx(x,y):
    return 2*x +4*np.pi*np.cos(2*x*np.pi)*np.sin(y*np.pi)

#Derivada de f respecto de y
def dfy(x,y):
    return 4*y+2*np.pi*np.sin(2*np.pi*x)*np.cos(np.pi*y)

#Gradiente de f
def gradF(x,y):
    return np.array([dfx(x,y), dfy(x,y)])
#Utilizar el gradiente descendente para minimizar la funcion

#Definicion de una funcion para testear learning rate
def testF(x,y):
    return np.power(x,2) + np.power(y,2)
def dtestFx(x,y):
    return 2*x
def dtestFy(x,y):
    return 2*y
def gradtestF(x,y):
    return np.array([dtestFx(x,y), dtestFy(x,y)])

print('Graficas sobre gradiete Descendiente')
#----------------------------------------------------
#Ejemplo de intentar encontra el minimo con un lr inadecuado
eta = 1
maxIter = 50
error2get = 1e-800
initial_point = np.array([2,2])

w, it, ws = gradient_descent(initial_point,eta,gradtestF,testF,error2get,maxIter)
###display_figure(3, testF, ws, 'plasma','eta=1',r'x^2+y^2')

#----------------------------------------
#Figuras para memoria, aplicando gradiente descendiente
eta = 0.01
initial_point = np.array([2,2])
w, it, ws = gradient_descent(initial_point,eta,gradtestF,testF,error2get,maxIter)
###display_figure(3, testF, ws, 'plasma','Test',r'x^2+y^2')

input("\n--- Pulsar tecla para continuar con el ejercicio  3---\n")

#-----------------------------
#Ejercicio 3a
eta = 0.01
error2get = 1e-100
#Ejecutar con 50 iteraciones como maximo
maxIter = 50
point = np.array([-1,1])
w, it_1,ws_1 = gradient_descent(point,eta,gradF,f1,error2get,maxIter,only_iters=True)

print ('Numero de iteraciones: ', it)
print ('Coordenadas obtenidas: (', w[0], ', ', w[1],')')
print()

###display_figure(3, f1, ws, 'plasma','3a, eta = 0.01',r'x^2+ 2y^2 +2sin(2\pi x)sin(\pi y)')

#Repetir el experimento pero para eta = 0.1
eta = 0.1
error2get = 1e-10
maxIter = 50
point = np.array([-1,1])
w, it_2,ws_2 = gradient_descent(point,eta,gradF,f1,error2get,maxIter,only_iters=(True))

print ('Numero de iteraciones: ', it)
print ('Coordenadas obtenidas: (', w[0], ', ', w[1],')')
'''
ws_1 = np.asarray(ws_1)
ws_2 = np.asarray(ws_2)
plt.plot(np.arange(it+1),f1(ws_1[:,0],ws_1[:,1]),'bo-')
plt.plot(np.arange(it+1),f1(ws_2[:,0],ws_2[:,1]),'yo-.')
plt.xlabel('Iteraciones')
plt.ylabel('Valor de $f1$')
plt.legend(['$\eta = 0.01$','$\eta = 0.1$'])
'''
###display_figure(3, f1, ws, 'plasma','3a, eta = 0.1',r'x^2+ 2y^2 +2sin(2\pi x)sin(\pi y)')

#----------------------------------------------------------
#Ejercicio 3b

#Este bloque de codigo pinta en 3D los caminos que sigue desde cada punto de inicio hasta el min en 50 iters
#Punto iniciales

'''
initial_point = np.array([[-0.5,-0.5],[1,1],[2.1,-2.1],[-3,3],[-2,2]])
#Display
rng_val = 3
from mpl_toolkits.mplot3d import Axes3D
x = np.linspace(-rng_val, rng_val, 50)
y = np.linspace(-rng_val, rng_val, 50)
X, Y = np.meshgrid(x, y)
Z = f1(X, Y) 
fig = plt.figure()
ax = Axes3D(fig,auto_add_to_figure=False)
fig.add_axes(ax)
ax.plot_surface(X, Y, Z, edgecolor='none', rstride=1,cstride=1, cmap='magma', alpha=.6)

for point in initial_point:
    for eta in [0.01,0.1]:
        #Calcular el gradiente desde cada punto y diferente eta
        w, it,ws = gradient_descent(point,eta,gradF,f1,error2get,maxIter,only_iters=(True))
        print('Para eta: ', eta)
        print('Para el punto: ', point )
        print ('Numero de iteraciones: ', it)
        print ('Coordenadas obtenidas: (', w[0], ', ', w[1],')')
        print()
        #display_figure(3, f1, ws, 'magma', '', f'${point} $, $\eta = {eta}$')
        ##--Como el ejemplo se ve mucho mejor con 0.01 pongo esta condicion
        if (len(ws)>0 and eta == 0.01):
            ws = np.asarray(ws)
            min_point = np.array([ws[-1,0],ws[-1,1]])
            min_point_ = min_point[:, np.newaxis]
            plt.plot(ws[:-1,0], ws[:-1,1], f1(ws[:-1,0], ws[:-1,1]),c='r', markersize=5,label=f'${point} $, $\eta = {eta}$')
            plt.plot(min_point_[0], min_point_[1], f1(min_point_[0], min_point_[1]), c='m', markersize=10,marker='*' )
            plt.legend()
plt.show()
'''
        
input("\n--- Pulsar tecla para continuar con el ejercicio  4---\n")


#Para calcular el plano podemos obtener 2 puntos a y b que son los que x_1 y x_2 son 0


###############################################################################
###############################################################################
###############################################################################
###############################################################################

input("\n--- Pulsar tecla para continuar con la parte de Regresion Lineal---\n")
print('\nEJERCICIO SOBRE REGRESION LINEAL\n')
print('Ejercicio 1\n')

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

    h = np.float64(x.dot(w)-y)
    #print(np.shape(h),h)
    h.dtype = np.float64
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



# Pseudoinversa	
def pseudoinverse(x,y):
    #X_inv = (X^T * X)^-1 * X^T
    X_ps_inv = np.dot(np.linalg.inv(np.dot(x.T,x)), x.T)

    w = X_ps_inv.dot(y)
    return w


# Lectura de los datos de entrenamiento

print("Leyendo datos\n")
x, y = readData('datos/X_train.npy', 'datos/y_train.npy')
# Lectura de los datos para el test
x_test, y_test = readData('datos/X_test.npy', 'datos/y_test.npy')


eta = 0.1
batch_size = 32
maxIter = 10000
error2get = 1e-8
w = np.zeros(3)

'''
print('Calculando SGD...')
w = sgd(x,y,eta,batch_size,maxIter,w,error2get)
print ('Bondad del resultado para grad. descendente estocastico:\n')
print ("Ein: ", Err(x,y,w))
print ("Eout: ", Err(x_test, y_test, w))
print ("w : ", w)
print()
'''
#---------------------------
'''
print('Calculando pseudo-inversa...')
w_invs = pseudoinverse(x, y)
print ('Bondad del resultado para inversa:\n')
print ("Ein: ", Err(x,y,w_invs))
print ("Eout: ", Err(x_test, y_test, w_invs))
print ("w : ", w_invs)
print()
'''


#plot_regresion(x, y, w, 'Gradiente descendiente Estocastico', 'Intensidad', 'Simetria',None,None)
#plot_regresion(x, y, w_invs, 'Matrix pseudo-inversa', 'Intensidad', 'Simetria',None,None)




input("\n--- Pulsar tecla para continuar con el ejercicio 2 de Regresion Lineal---\n")

#Seguir haciendo el ejercicio...

#print('Ejercicio 2\n')
# Simula datos en un cuadrado [-size,size]x[-size,size]


def simula_unif(N, d, size):
	return np.random.uniform(-size,size,(N,d))

def sign(x):
	if x >= 0:
		return 1
	return -1

def f(x1, x2):
	return sign((x1-0.2)**2+x2**2-0.6) 


#Seguir haciendo el ejercicio...

N = 1000
size = 1 
d = 2
data_set = simula_unif(N, d, size)

#Muestra de los datos distribuidos uniformemente 
'''
fig = plt.figure()
ax_unif= fig.add_subplot()
ax_unif.scatter(data_set[:,0],data_set[:,1])
plt.title('DataSet')
'''



#Dado un conjunto de datos podemos crear unas etiquetas a partir de la funcion 
#para decidir a que grupo pertenece
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


w = np.zeros(3);
w[0] = 1
#Para que siga con la misma forma que antes, añado una columna de 1's al principio del data_set (x).

new_y = add_labels(data_set,f)
data_set = np.insert(data_set,0,np.ones(len(data_set)),axis=1)
new_y = add_noise(new_y, 0.1)

#Muestra los puntos diferenciados por etiquetas
'''
fig = plt.figure()
ax_unif2= fig.add_subplot()
ax_unif2.scatter(data_set[:,1],data_set[:,2],c=new_y)
plt.title('Diferenciando tipos')
'''

import time
#Vamos a comprobar cuantas iteraciones hacen faltan para ver si mejora

'''
error2get = 1e-8
eta = 0.1
batch_size = 32
analisis = []
for i in range(0,100,2):
    w = sgd(data_set, new_y, eta, batch_size , i, w, error2get)
    analisis.append([i,Err(data_set, new_y, w)])
    
analisis = np.array(analisis, np.float64)    

fig = plt.figure()
ax_ana= fig.add_subplot()
ax_ana.plot(analisis[:,0],analisis[:,1])
plt.title('How important the maxIter is?')
plt.xlabel('Iteraciones')
plt.ylabel('Error')



#Problema del error medio, es una mettrica relativa
w = sgd(data_set, new_y, eta, batch_size, maxIter, w, error2get)
#print(np.shape(w),w)
plot_regresion(data_set, new_y, w, 'Regresion', '', '',[-1,1],[-1,1])


print ('Bondad del resultado el conjunto de datos:\n')
print ("Ein: ", Err(data_set,new_y,w))
print ("w : ", w)

'''

'''
N = 1000
size = 1 
d = 2
w = np.zeros(3)
w[0] = 1

eta = 0.1
batch_size = 32
maxIter = 20
error2get = 1e-6
mean_err = []
start_time = time.time()
for exp in range(1000):
    data_set_n = simula_unif(N, d, size)
    
    y_n = add_labels(data_set_n,f)
    y_n = add_noise(y_n,0.1)
    data_set_n = np.insert(data_set_n,0,np.ones(len(data_set)),axis=1)
    
    w_n = sgd(data_set_n, y_n, eta, batch_size, maxIter, w, error2get)

    mean_err.append(Err(data_set_n,y_n,w_n))    

mean_err = np.array(mean_err, np.float64)
print ('Bondad del resultado el conjunto de datos tras 1000 ejecuciones:\n')
print ("Ein: ",mean_err.mean())
print('Ha tardado ' , int(time.time() - start_time))
'''

#Apartado d2, generar otros mil datos para tests

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
    
    test_data_set_n = simula_unif(N, d, size)
    test_y_n = add_labels(test_data_set_n, f)
    test_y_n = add_noise(test_y_n,0.1)
    
    y_n = add_labels(data_set_n,f)
    y_n = add_noise(y_n,0.1)

    data_set_n = np.insert(data_set_n,0,np.ones(len(data_set)),axis=1)
    test_data_set_n = np.insert(test_data_set_n,0,np.ones(len(data_set)),axis=1)
    
    w_n = sgd(data_set_n, y_n, eta, batch_size, maxIter, w, error2get)
    mean_err_in.append(Err(data_set_n,y_n,w_n))
    mean_err_out.append(Err(test_data_set_n, test_y_n, w_n))

    

mean_err_in = np.array(mean_err_in, np.float64)
mean_err_out = np.array(mean_err_out, np.float64)
print ('Bondad del resultado el conjunto de datos tras 1000 ejecuciones:\n')
print ("Ein: ",mean_err_in.mean())
print ("Eout: ",mean_err_out.mean())
print('Ha tardado ' , int(time.time() - start_time), ' segundos')
'''


def vectorFeatures(x1,x2):
    vec_features = np.zeros((x1.size,6))
    vec_features[:,0] = 1
    vec_features[:,1] = x1
    vec_features[:,2] = x2
    vec_features[:,3] = x1*x2
    vec_features[:,4] = np.power(x1,2)
    vec_features[:,5] = np.power(x2,2)
    return vec_features

#-----------------------------------------------------------
#Repetir el esperimento pero con carcteristicas no lineales
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

#Ajustar un modelo no lineal
'''
w = np.zeros(6)
data_set = simula_unif(1000, 2, 1)
y_n = add_labels(data_set,f)
data_set= np.insert(data_set,0,np.ones(len(data_set)),axis=1)
y_n = add_noise(y_n,0.1)
sample = vectorFeatures(data_set[:,1], data_set[:,2])

from itertools import cycle
cycol = cycle('bgrcmk')

fig = plt.figure()
ax_e1= fig.add_subplot()

eta = 0.01
maxIter = 20000
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
def non_linear_plot(X, y, w_s,title=None, xlabel=None, ylabel=None):
    
    fig = plt.figure()
    ax= fig.add_subplot()
    
    ax.scatter(X[:,1],X[:,2],c=y)
    
    X_min0, X_max0 = np.min(X[:,1]), np.max(X[:,1])
    X_min1, X_max1 = np.min(X[:,2]), np.max(X[:,2])
    x_t, y_t = np.meshgrid(np.linspace(X_min0-0.5, X_max0+0.5, 100),np.linspace(X_min1-0.5, X_max1+0.5, 100))

    f_t = w_s[0] + w_s[1]*x_t + w_s[2]*y_t + w_s[3]*x_t*y_t + w_s[4]*x_t*x_t + w_s[5]*y_t*y_t
    #print(f_t)
    #f_t = vectorFeatures(x_t, y_t)
    ax.contour(x_t, y_t, f_t, [0])
    plt.xlim([-1,1])
    plt.ylim([-1,1])
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)

#------------------------------------------
'''
w = np.zeros(6)
data_set = simula_unif(1000, 2, 1)
y_n = add_labels(data_set,f)
data_set= np.insert(data_set,0,np.ones(len(data_set)),axis=1)
y_n = add_noise(y_n,0.1)
sample = vectorFeatures(data_set[:,1], data_set[:,2]) 

eta = 0.01
batch = 16

w,iterations_sgd,error = sgd2(sample, y_n, eta, batch, maxIter, w, error2get)
#
non_linear_plot(data_set, y_n, w,title="Non Linear", xlabel="r$x_1$", ylabel="r$x_2$")




print ('Bondad del resultado el conjunto de datos:\n')
print ("Ein: ", Err(sample,y_n,w))
print ("w : ", w)
print('Iteraciones: ' , iterations_sgd)
'''





eta = 0.01
batch_size = 16
maxIter = 1000
error2get = 1e-10
mean_err_in = []
mean_err_out = []
start_time = time.time()
size = 50
w = np.zeros(6)

N = 1000
size = 1 
d = 2

for exp in range(50):
    
    data_set_n = simula_unif(N, d, size)
    #test_data_set_n = simula_unif(N, d, size)
    
    
    y_n = add_labels(data_set_n,f)
    data_set_n = np.insert(data_set_n,0,np.ones(len(data_set)),axis=1)
    y_n = add_noise(y_n,0.1)
    
    #test_y_n = add_labels(test_data_set_n, f)
    #test_y_n = add_noise(test_y_n,0.1)
    
    
    #test_data_set_n = np.insert(test_data_set_n,0,np.ones(len(data_set)),axis=1)
    
    sample = vectorFeatures(data_set_n[:,1], data_set_n[:,2]) 
    #sample_test = vectorFeatures(test_data_set_n[:,1], test_data_set_n[:,2])
    
    w_n,iterations_sgd,error = sgd2(sample, y_n, eta, batch_size, maxIter, w, error2get)
    
    mean_err_in.append(Err(sample,y_n,w_n))
    #non_linear_plot(data_set_n, y_n, w_n,title="Non Linear", xlabel="r$x_1$", ylabel="r$x_2$")
    #mean_err_out.append(Err(sample_test, test_y_n, w_n))


mean_err_in = np.array(mean_err_in, np.float64)
#mean_err_out = np.array(mean_err_out, np.float64)
print ('Bondad del resultado el conjunto de datos tras 1000 ejecuciones:\n')
print ("Ein: ",mean_err_in.mean())
#print ("Eout: ",mean_err_out.mean())
print('Ha tardado ' , int(time.time() - start_time), ' segundos')



#``````````````````````````````
# TODO : MIRAR EN CUANTAS ITERACIONES CONVERGE LA SEGUNDA OPCION Y A PARTIR DE ESO HACER EL TEST
#``````````````````````








