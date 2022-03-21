#Ejercicios 3 Valores equidistantes entre 0 y 4pi

import math 
import numpy as np
import matplotlib.pyplot as plt

#Primera funcion 10^-5 * sinh
coord_x = np.linspace(0,4*math.pi,100)
coord_y = [pow(10,-5)*math.sinh(i) for i in coord_x]
plt.plot(coord_x, coord_y, color='g', linestyle='--')

#Segunda funcion cos
coord_y = [math.cos(i) for i in coord_x]
plt.plot(coord_x, coord_y, color='b', linestyle='--')

#Tercera funcion
coord_y = [math.tanh(2*math.sin(i)- 4*math.cos(i)) for i in coord_x]
plt.plot(coord_x, coord_y, color='r', linestyle='--')

#Determino el limite de los ejes
plt.xlim([-1,13])
plt.ylim([-1,1.5])
plt.show()