# -*- coding: utf-8 -*-
"""
TRABAJO 2
Nombre Estudiante: Jose Luis Molina Aguilar
Datos del profe: Manuel Jesus Cobo ,Manolo
correo: mjcobo@decsai.ugr.es
"""
import numpy as np
import matplotlib.pyplot as plt

#no CAMBIA LA RECTA EN EL EJERCICIOS, esa recta es la mejor ya que es la que he tuilizado para asignar las etiquetas
#ya que esa recta es la que queremos escoger ya que de media sera la mejor, anque tengamos casos en las que baje o sube

#Cuando intentamos utilziar toras ecuacionas mas complejas estamos sobreestimando ya que basicamente te estas aprendiendo ese caso y no estas GENERALIZANDO
#eL NUMERO DE ITERACIONES SE PONE DENTRO DEL IF

# Fijamos la semilla#
#BONUS DIMENSION = 3
#BONUS CARDINALIDAD 1

np.random.seed(1)


def simula_unif(N, dim, rango):
	return np.random.uniform(rango[0],rango[1],(N,dim))

def simula_gauss(N, dim, sigma):
    media = 0    
    out = np.zeros((N,dim),np.float64)        
    for i in range(N):
        # Para cada columna dim se emplea un sigma determinado. Es decir, para 
        # la primera columna (eje X) se usará una N(0,sqrt(sigma[0])) 
        # y para la segunda (eje Y) N(0,sqrt(sigma[1]))
        out[i,:] = np.random.normal(loc=media, scale=np.sqrt(sigma), size=dim)
    
    return out


def simula_recta(intervalo):
    points = np.random.uniform(intervalo[0], intervalo[1], size=(2, 2))
    x1 = points[0,0]
    x2 = points[1,0]
    y1 = points[0,1]
    y2 = points[1,1]
    # y = a*x + b
    a = (y2-y1)/(x2-x1) # Calculo de la pendiente.
    b = y1 - a*x1       # Calculo del termino independiente.
    
    return a, b

def miss_classified(train,test):
    error= 0
    for i in np.arange(test.size):
        if(train[i] != test[i]):
            error+=1
    return (error/test.size)*100

def miss_classified2(train,test):
    error= 0
    for i in np.arange(test.size):
        if(train[i] > 0 and  test[i] < 0):
            error+=1
        elif(train[i] < 0 and  test[i] > 0):
            error+=1
    return (error/test.size)*100
# EJERCICIO 1.1: Dibujar una gráfica con la nube de puntos de salida correspondiente

x = simula_unif(50, 2, [-50,50])

#CODIGO DEL ESTUDIANTE
fig_ej1a = plt.figure()
ax_ej1a = fig_ej1a.add_subplot()
ax_ej1a.scatter(x[:,0],x[:,1])
ax_ej1a.set_title("Nube de puntos aleatoria uniforme")



x = simula_gauss(50, 2, np.array([5,7]))
#CODIGO DEL ESTUDIANTE

fig_ej1b = plt.figure()
ax_ej1b = fig_ej1b.add_subplot()
ax_ej1b.scatter(x[:,0],x[:,1])
ax_ej1b.set_title("Nube de puntos aleatoria Gausiana")
#input("\n--- Pulsar tecla para continuar ---\n")


###############################################################################
###############################################################################
###############################################################################


# EJERCICIO 1.2: Dibujar una gráfica con la nube de puntos de salida correspondiente

# La funcion np.sign(0) da 0, lo que nos puede dar problemas
def signo(x):
	if x >= 0:
		return 1
	return -1

def f(x, y, a, b):
	return signo(y - a*x - b)

#CODIGO DEL ESTUDIANTE
data = simula_unif(100, 2, [-50,50])
labels = []
a,b = simula_recta([-50,50])

for coord in data:
    l = f(coord[0], coord[1], a, b)
    labels.append(l)
labels = np.array(labels,np.float64)
def plot1(data,labels,title):
    fig_ej12 = plt.figure()
    ax_ej12 = fig_ej12.add_subplot()
    ax_ej12.scatter(data[:,0],data[:,1],c=labels)
    ax_ej12.plot(np.linspace(-50,50,labels.size), a * np.linspace(-50,50,labels.size)+b)
    ax_ej12.set_title("Grafica sin ruido, clasificacion perfecta")

plot1(data,labels,"Grafica sin ruido, clasificacion perfecta")

#input("\n--- Pulsar tecla para continuar ---\n")

#Añade a un conjunto de etiquetas un 'percent' de datos en forma de ruido
def add_noise(labels,percent=0.1):
    #Escojo las etiquetas tanto positivas como negativas
    pos_labels = np.where(labels > 0)
    neg_labels = np.where(labels < 0)
    
    pos_labels = np.array(pos_labels)
    neg_labels = np.array(neg_labels)
    #Escogo sobre cada una(positivas o negativas) el porcentaje de ruido
    pos_index = np.random.choice(pos_labels.size, size= int(percent*pos_labels.size),replace=False)
    neg_index = np.random.choice(neg_labels.size, size= int(percent*neg_labels.size),replace=False)
    #Devolvemos: Los indices de las etiquetas(positivas y negativas)
    #           y sus posiciones.
    return pos_labels, neg_labels, pos_index, neg_index

# 1.2.b. Dibujar una gráfica donde los puntos muestren el resultado de su etiqueta, junto con la recta usada para ello
# Array con 10% de indices aleatorios para introducir ruido

#CODIGO DEL ESTUDIANTE
def add_noise_labels(labels):
    pos_labels, neg_labels, pos_index, neg_index = add_noise(labels);
    noise_labels = labels.copy()
    for i in pos_index:
        noise_labels[pos_labels[0][i]]*=-1
    for i in neg_index:
        noise_labels[neg_labels[0][i]]*=-1
        
    return noise_labels

noise_labels = add_noise_labels(labels)

plot1(data,noise_labels,"Grafica con ruido {}".format(miss_classified(noise_labels, labels)))
'''
fig_ej12b = plt.figure()
ax_ej12b = fig_ej12b.add_subplot()
ax_ej12b.scatter(data[:,0],data[:,1],c=noise_labels)
ax_ej12b.plot(np.linspace(-50,50,noise_labels.size), a * np.linspace(-50,50,noise_labels.size)+b)
title = "Grafica con ruido {}".format(miss_classified(noise_labels, labels))
ax_ej12b.set_title(title)
'''
#input("\n--- Pulsar tecla para continuar ---\n")

###############################################################################
###############################################################################
###############################################################################

# EJERCICIO 1.3: Supongamos ahora que las siguientes funciones definen la frontera de clasificación de los puntos de la muestra en lugar de una recta

def plot_datos_cuad(X, y, fz, title='Point cloud plot', xaxis='x axis', yaxis='y axis'):
    #Preparar datos
    min_xy = X.min(axis=0)
    max_xy = X.max(axis=0)
    border_xy = (max_xy-min_xy)*0.01
    
    #Generar grid de predicciones
    xx, yy = np.mgrid[min_xy[0]-border_xy[0]:max_xy[0]+border_xy[0]+0.001:border_xy[0], 
                      min_xy[1]-border_xy[1]:max_xy[1]+border_xy[1]+0.001:border_xy[1]]
    grid = np.c_[xx.ravel(), yy.ravel(), np.ones_like(xx).ravel()]
    pred_y = fz(grid)
    # pred_y[(pred_y>-1) & (pred_y<1)]
    pred_y = np.clip(pred_y, -1, 1).reshape(xx.shape)
    
    #Plot
    f, ax = plt.subplots(figsize=(8, 6))
    contour = ax.contourf(xx, yy, pred_y, 50, cmap='RdBu',vmin=-1, vmax=1)
    ax_c = f.colorbar(contour)
    ax_c.set_label('$f(x, y)$')
    ax_c.set_ticks([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1])
    ax.scatter(X[:, 0], X[:, 1], c=y, s=50, linewidth=2, 
                cmap="RdYlBu", edgecolor='white')
    
    XX, YY = np.meshgrid(np.linspace(round(min(min_xy)), round(max(max_xy)),X.shape[0]),np.linspace(round(min(min_xy)), round(max(max_xy)),X.shape[0]))
    positions = np.vstack([XX.ravel(), YY.ravel()])
    ax.contour(XX,YY,fz(positions.T).reshape(X.shape[0],X.shape[0]),[0], colors='black')
    
    ax.set(
       xlim=(min_xy[0]-border_xy[0], max_xy[0]+border_xy[0]), 
       ylim=(min_xy[1]-border_xy[1], max_xy[1]+border_xy[1]),
       xlabel=xaxis, ylabel=yaxis)
    plt.title(title)
    plt.show()
    
    
#CODIGO DEL ESTUDIANTE
#--------------------F1--------------------#
def f1(x):
    return (x[:,0]-10)**2 + (x[:,1]-20)**2 -400

labels1 = f1(data)
'''
pos_labels, neg_labels, pos_index, neg_index = add_noise(labels);
noise_labels = labels.copy()

for i in pos_index:
    noise_labels[pos_labels[0][i]]*=-1
for i in neg_index:
    noise_labels[neg_labels[0][i]]*=-1
 '''   
plot_datos_cuad(data, noise_labels, f1,title="Classif err de f1 es {}".format(miss_classified2(labels1,labels)))
print("Error en la clasificacion de f1 es {}".format(miss_classified2(labels1,labels)))

#--------------------F2--------------------#
def f2(x):
    return 0.5*(x[:,0]+10)**2 + (x[:,1]-20)**2 -400

labels2 = f2(data)
'''
pos_labels, neg_labels, pos_index, neg_index = add_noise(labels);
noise_labels = labels.copy()

for i in pos_index:
    noise_labels[pos_labels[0][i]]*=-1
for i in neg_index:
    noise_labels[neg_labels[0][i]]*=-1
 '''   
plot_datos_cuad(data, noise_labels, f2,title="Classif err de f2 es {}".format(miss_classified2(labels2,labels)))
print("Error en la clasificacion de f2 es {}".format(miss_classified2(labels2,labels)))

#--------------------F3--------------------#
def f3(x):
    return 0.5*(x[:,0]-10)**2 + (x[:,1]-20)**2 -400

labels3 = f3(data)
'''
pos_labels, neg_labels, pos_index, neg_index = add_noise(labels);
noise_labels = labels.copy()
for i in pos_index:
    noise_labels[pos_labels[0][i]]*=-1
for i in neg_index:
    noise_labels[neg_labels[0][i]]*=-1
   ''' 
plot_datos_cuad(data, noise_labels, f3,title="Classif err de f3 es {}".format(miss_classified2(labels3,labels)))
print("Error en la clasificacion de f3 es {}".format(miss_classified2(labels3,labels)))

#--------------------F4--------------------#
def f4(x):
    return x[:,1] - 20*(x[:,0]**2) -5*x[:,0] +3

labels4 = f4(data)
'''
pos_labels, neg_labels, pos_index, neg_index = add_noise(labels);
noise_labels = labels.copy()

for i in pos_index:
    noise_labels[pos_labels[0][i]]*=-1
for i in neg_index:
    noise_labels[neg_labels[0][i]]*=-1
 '''   
plot_datos_cuad(data, noise_labels, f4,title="Classif err de f4 es {}".format(miss_classified2(labels4,labels)))
print("Error en la clasificacion de f4 es {}".format(miss_classified2(labels4,labels)))
#input("\n--- Pulsar tecla para continuar ---\n")

###############################################################################
###############################################################################
###############################################################################

# EJERCICIO 2.1: ALGORITMO PERCEPTRON

def ajusta_PLA(datos, label, max_iter, vini):
    i =0
    cambio = True
    w = vini
    while cambio and i < max_iter:
        cambio = False
        for idx,xi in enumerate(datos):
            i +=1
            if(signo(w.dot(xi)) != label[idx]):
                w = w +xi*label[idx]
                cambio = True
    return w,i

#CODIGO DEL ESTUDIANTE
data = simula_unif(100, 2, [-50,50])
a,b = simula_recta([-50,50])
labels = []
for coord in data:
    l = f(coord[0], coord[1], a, b)
    labels.append(l)
labels = np.array(labels,np.float64)
data = np.insert(data,0,np.ones(len(data)),axis=1)


##Primero el PLA
MAX_ITERS = 50000
ini = np.zeros(3)
w, count = ajusta_PLA(data, labels, MAX_ITERS, ini)
print(w,count,'\n')


# Random initializations
iterations = []
for i in range(0,10):
    #CODIGO DEL ESTUDIANTE
    wini = np.random.sample(3)
    w, iters =  ajusta_PLA(data, labels, MAX_ITERS, wini)
    print("Iteracion{}".format(i+1))
    print("Pesos iniciales = {}".format(wini))
    print("Pesos finales = {}".format(w))
    print("Iteracoines necesarias = {}".format(iters))
    iterations.append(iters)
    print()
    
print('Valor medio de iteraciones necesario para converger: {}'.format(np.mean(np.asarray(iterations))))

#input("\n--- Pulsar tecla para continuar ---\n")

# Ahora con los datos del ejercicio 1.2.b

ini = np.zeros(3)
pos_labels, neg_labels, pos_index, neg_index = add_noise(labels);

noise_labels = add_noise_labels(labels)
    
w, count = ajusta_PLA(data, labels, MAX_ITERS, ini)
print(w,count,'\n')

# Random initializations
iterations = []
for i in range(0,10):
    #CODIGO DEL ESTUDIANTE
    wini = np.random.sample(3)
    w, iters =  ajusta_PLA(data, noise_labels, MAX_ITERS, wini)
    print("Iteracion{}".format(i+1))
    print("Pesos iniciales = {}".format(wini))
    print("Pesos finales = {}".format(w))
    print("Iteracoines necesarias = {}".format(iters))
    iterations.append(iters)
    print()
    
print('Valor medio de iteraciones necesario para converger: {}'.format(np.mean(np.asarray(iterations))))
#CODIGO DEL ESTUDIANTE


#input("\n--- Pulsar tecla para continuar ---\n")

###############################################################################
###############################################################################
###############################################################################
'''
# EJERCICIO 3: REGRESIÓN LOGÍSTICA CON STOCHASTIC GRADIENT DESCENT
def gradient(x,y,w):
    s = 0
    s = y*x/(1+np.exp(y*w.dot(x)))
    return -s

def sgdRL(x,y,max_iters,w, mini_batch_size, eta=0.01, epsilon=0.01):
    #CODIGO DEL ESTUDIANTE
    iters=0
    index = np.array(range(0,x.shape[0]))
    for i in np.arange(max_iters):
        w_old= np.array(w)
        np.random.shuffle(index)
        for j in np.arange(w.size):
            w = w- (eta * gradient(x[i], y[i], w))
        iters+=1
        if np.linalg.norm(w_old-w) < epsilon:
            break
    return w, iters

def Err(x,y,w):
    result = np.log(1+np.exp(-(x.dot(w)*y)))
    return result.mean()


#w,it = sgdRL(datos, labels, MAX_ITERS, w, mini_batch_size)
a = -(w[0]/w[2])/(w[0]/w[1])
b = -w[0]/w[2]

# generamos un conjunto de datos uniformes en el rango[-50,50],
# calculamos las respectivas 'y' del conjunto generado
x = np.linspace(-50,50,100)
y = a*x +b

#Gráfica

fig_ej12b = plt.figure()
ax_ej12b = fig_ej12b.add_subplot()
ax_ej12b.scatter(data[:,0],data[:,1],c=noise_labels)
ax_ej12b.plot(np.linspace(-50,50,noise_labels.size), a * np.linspace(-50,50,noise_labels.size)+b)
title = "Grafica con ruido {}".format(miss_classified(noise_labels, labels))
ax_ej12b.set_title(title)

plt.axis([-60,60,-60,60])  
plt.plot(x,y, 'r--', label="recta a*x + b ")
plt.plot(x,y,'k--', label='a*x + b respecto w')
ax_ej12b.scatter(data[:,0],data[:,1],c=noise_labels)
plt.title('Ajuste PLA, vini[0,0,0]')
plt.xlabel("EJE X")
plt.ylabel("EJE Y")
plt.legend()
plt.show()
print("Numero de iterationes (vector inicial a 0): ", count)

input("\n--- Pulsar tecla para continuar ---\n")

#CODIGO DEL ESTUDIANTE

#input("\n--- Pulsar tecla para continuar ---\n")
    


# Usar la muestra de datos etiquetada para encontrar nuestra solución g y estimar Eout
# usando para ello un número suficientemente grande de nuevas muestras (>999).


#CODIGO DEL ESTUDIANTE


#input("\n--- Pulsar tecla para continuar ---\n")


###############################################################################
###############################################################################
###############################################################################
#BONUS: Clasificación de Dígitos


# Funcion para leer los datos
def readData(file_x, file_y, digits, labels):
	# Leemos los ficheros	
	datax = np.load(file_x)
	datay = np.load(file_y)
	y = []
	x = []	
	# Solo guardamos los datos cuya clase sea la digits[0] o la digits[1]
	for i in range(0,datay.size):
		if datay[i] == digits[0] or datay[i] == digits[1]:
			if datay[i] == digits[0]:
				y.append(labels[0])
			else:
				y.append(labels[1])
			x.append(np.array([1, datax[i][0], datax[i][1]]))
			
	x = np.array(x, np.float64)
	y = np.array(y, np.float64)
	
	return x, y

# Lectura de los datos de entrenamiento
x, y = readData('datos/X_train.npy', 'datos/y_train.npy', [4,8], [-1,1])
# Lectura de los datos para el test
x_test, y_test = readData('datos/X_test.npy', 'datos/y_test.npy', [4,8], [-1,1])


#mostramos los datos
fig, ax = plt.subplots()
ax.plot(np.squeeze(x[np.where(y == -1),1]), np.squeeze(x[np.where(y == -1),2]), 'o', color='red', label='4')
ax.plot(np.squeeze(x[np.where(y == 1),1]), np.squeeze(x[np.where(y == 1),2]), 'o', color='blue', label='8')
ax.set(xlabel='Intensidad promedio', ylabel='Simetria', title='Digitos Manuscritos (TRAINING)')
ax.set_xlim((0, 1))
plt.legend()
plt.show()

fig, ax = plt.subplots()
ax.plot(np.squeeze(x_test[np.where(y_test == -1),1]), np.squeeze(x_test[np.where(y_test == -1),2]), 'o', color='red', label='4')
ax.plot(np.squeeze(x_test[np.where(y_test == 1),1]), np.squeeze(x_test[np.where(y_test == 1),2]), 'o', color='blue', label='8')
ax.set(xlabel='Intensidad promedio', ylabel='Simetria', title='Digitos Manuscritos (TEST)')
ax.set_xlim((0, 1))
plt.legend()
plt.show()

#input("\n--- Pulsar tecla para continuar ---\n")

#LINEAR REGRESSION FOR CLASSIFICATION 

#CODIGO DEL ESTUDIANTE


#input("\n--- Pulsar tecla para continuar ---\n")



#POCKET ALGORITHM
  
#CODIGO DEL ESTUDIANTE




#input("\n--- Pulsar tecla para continuar ---\n")


#COTA SOBRE EL ERROR

#CODIGO DEL ESTUDIANTE
'''