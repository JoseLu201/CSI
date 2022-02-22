#Ejercicios 3 Valores equidistantes entre 0 y 4pi

import math 
import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris
def equis(inicio , fin, step):
    x = fin - inicio
    v_e = x/step
    return v_e

print('valor equis ' , equis(0,4*math.pi,100))
#plt.figure()
coord_x = np.arange(0,4*math.pi, equis(0,4*math.pi,100))
coord_y = [math.sinh(i) for i in coord_x]


plt.plot(coord_x, coord_y, color='g', linestyle='--')

coord_y = [math.cos(i) for i in coord_x]
plt.plot(coord_x, coord_y, color='b', linestyle='--')


coord_y = [math.tanh(2*math.sin(i)- 4*math.cos(i)) for i in coord_x]
plt.plot(coord_x, coord_y, color='r', linestyle='--')
plt.xlim([-1,13])
plt.ylim([-1,1.5])
plt.show()