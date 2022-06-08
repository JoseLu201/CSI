
import numpy as np
import matplotlib.pyplot as plt
import time

secundary_things = False

np.random.seed(1)

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


def vectorFeatures(x1,x2):
    vec_features = np.zeros((x1.size,6))
    vec_features[:,0] = 1
    vec_features[:,1] = x1
    vec_features[:,2] = x2
    vec_features[:,3] = x1*x2
    vec_features[:,4] = np.power(x1,2)
    vec_features[:,5] = np.power(x2,2)
    return vec_features

def Err(x,y,w):
    #Error cuadratico medio
    # (1/n)*(x*w-y)^2
    h = np.float64(x.dot(w)-y)
    h.dtype = np.float64
    ans = np.power(h,2)
    return ans.mean()


# Simula datos en un cuadrado [-size,size]x[-size,size]


def simula_unif(N, d, size):
	return np.random.uniform(-size,size,(N,d))

def sign(x):
	if x >= 0:
		return 1
	return -1

def f(x1, x2):
	return sign((x1-0.2)**2+x2**2-0.6) 
#-----------------------------------------------------------
#Repetir el esperimento pero con carcteristicas no lineales
def gradient2(x,y,w):
    suma = np.sum(x.dot(w)) - y
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
    
    while(iterations < maxIter):
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


eta = 0.01
batch_size = 16
maxIter = 1000
error2get = 1e-5
mean_err_in = []
mean_err_out = []
start_time = time.time()

w = np.zeros(6)

N = 1000
size = 1 
d = 2

for exp in range(N):
    
    data_set_n = simula_unif(N, d, size)
    test_data_set_n = simula_unif(N, d, size)
    
    
    y_n = add_labels(data_set_n,f)
    data_set_n = np.insert(data_set_n,0,np.ones(len(data_set_n)),axis=1)
    y_n = add_noise(y_n,0.1)
    
    test_y_n = add_labels(test_data_set_n, f)
    test_data_set_n = np.insert(test_data_set_n,0,np.ones(len(test_data_set_n)),axis=1)
    test_y_n = add_noise(test_y_n,0.1)
    
    
    sample = vectorFeatures(data_set_n[:,1], data_set_n[:,2]) 
    sample_test = vectorFeatures(test_data_set_n[:,1], test_data_set_n[:,2])
    
    w_n,iterations_sgd,error = sgd2(sample, y_n, eta, batch_size, maxIter, w, error2get)
    
    mean_err_in.append(Err(sample,y_n,w_n))
    print ("Ein: ",Err(sample,y_n,w_n))
    mean_err_out.append(Err(sample_test, test_y_n, w_n))


mean_err_in = np.array(mean_err_in, np.float64)
mean_err_out = np.array(mean_err_out, np.float64)
print ('Bondad del resultado el conjunto de datos tras 1000 ejecuciones mo lineal:\n')
print ("Ein: ",mean_err_in.mean())
#print ("w : ", w_s)
print ("Eout: ",mean_err_out.mean())
print('Ha tardado ' , int(time.time() - start_time), ' segundos')

