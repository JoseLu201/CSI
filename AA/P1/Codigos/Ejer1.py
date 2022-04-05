# -*- coding: utf-8 -*-
"""
Created on Thu Mar 31 13:01:30 2022

@author: JoseL
"""

import numpy as np
import matplotlib.pyplot as plt

import time

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
        
    if(only_iters == True):
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
error2get = 1e-1000
#Ejecutar con 50 iteraciones como maximo
maxIter = 50
point = np.array([-1,1])
w, it,ws = gradient_descent(point,eta,gradF,f1,error2get,maxIter,only_iters=True)

print ('Numero de iteraciones: ', it)
print ('Coordenadas obtenidas: (', w[0], ', ', w[1],')')
print()

###display_figure(3, f1, ws, 'plasma','3a, eta = 0.01',r'x^2+ 2y^2 +2sin(2\pi x)sin(\pi y)')

#Repetir el experimento pero para eta = 0.1
eta = 0.1
error2get = 1e-10
#Ejecutar con 50 iteraciones como maximo
maxIter = 50
point = np.array([-1,1])
w, it,ws = gradient_descent(point,eta,gradF,f1,error2get,maxIter,only_iters=(True))

print ('Numero de iteraciones: ', it)
print ('Coordenadas obtenidas: (', w[0], ', ', w[1],')')

###display_figure(3, f1, ws, 'plasma','3a, eta = 0.1',r'x^2+ 2y^2 +2sin(2\pi x)sin(\pi y)')


#Ejercicio 3b
initial_point = np.array([[-0.5,-0.5],[1,1],[2.1,-2.1],[-3,3],[-2,2]])

for point in initial_point:
    for eta in [0.01,0.1]:
        w, it,ws = gradient_descent(point,eta,gradF,f1,error2get,maxIter,only_iters=(True))
        print('Para eta: ', eta)
        print('Para el punto: ', point )
        print ('Numero de iteraciones: ', it)
        print ('Coordenadas obtenidas: (', w[0], ', ', w[1],')')
        print()
        if(eta == 0.01): 
            ####display_figure(3, f1, ws, 'plasma',str(point),r'$x^2 +2y^2 +2sin(2\pi x)sin(\pi x)$')
            print()


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
    ans = np.power((x.dot(w)-y),2)
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

print('Calculando SGD...')
time_sgd = time.time()
w = sgd(x,y,eta,batch_size,maxIter,w,error2get)
print ('Bondad del resultado para grad. descendente estocastico:\n')
print ("Ein: ", Err(x,y,w))
print ("Eout: ", Err(x_test, y_test, w))
print ("w : ", w)
print("SGD ha tardado {} segundos\n".format(time.time()-time_sgd))

#---------------------------

print('Calculando pseudo-inversa...')
time_inv = time.time()
w_invs = pseudoinverse(x, y)
print ('Bondad del resultado para inversa:\n')
print ("Ein: ", Err(x,y,w_invs))
print ("Eout: ", Err(x_test, y_test, w_invs))
print ("w : ", w_invs)
print("Pseudo inversa ha tardado {} segundos\n".format(time.time()-time_inv))



#--------------------------
def plot_regresion(x,y,w,title,xlabel,ylabel,xlim,ylim):
    fig = plt.figure()
    ax= fig.add_subplot()
    ax.scatter(x[:,1],x[:,2],c=y)
    ax.plot([ -w[0]/w[1] - w[2]/w[1], -w[0]/w[2] - w[1]/w[2]],color='red')
    plt.title(title)

    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    plt.xlim(xlim)
    plt.ylim(ylim)

plot_regresion(x, y, w, 'Gradiente descendiente Estocastico', 'Intensidad', 'Simetria',None,None)
plot_regresion(x, y, w_invs, 'Matrix pseudo-inversa', 'Intensidad', 'Simetria',None,None)




#input("\n--- Pulsar tecla para continuar con el ejercicio 2 de Regresion Lineal---\n")