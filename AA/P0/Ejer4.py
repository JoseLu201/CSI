#Ejercicios4

import numpy as np
import matplotlib.pyplot as plt


def f1(x,y):
   return( 1- abs(x+y) - abs(y-x))
def f2(x,y):
   return( x*y*np.exp(-x**2-y**2))

fig = plt.figure(figsize=plt.figaspect(0.5))
ax = fig.add_subplot(1, 2, 1, projection='3d')

x = np.linspace(-6, 6, 30)
y = np.linspace(-6, 6, 30)

X, Y = np.meshgrid(x, y)
Z = f1(X, Y)


fig1 = ax.plot_surface(X, Y, Z, rstride=1, cstride=1,cmap='magma', edgecolor='none')
ax.set_title('Piramide')


ax = fig.add_subplot(1, 2, 2, projection='3d')
ax.set_xlim3d(-2, 2,auto=True)
ax.set_ylim3d(-2, 2)
ax.set_zlim3d(-0.15, 0.15)

x = np.linspace(-2, 2, 100)
#asdf
y = np.linspace(-2, 2, 100)



X, Y = np.meshgrid(x, y)
Z = f2(X, Y)
ax.plot_surface(X, Y, Z,cmap='viridis', edgecolor='none')
ax.set_title('x*y*e^(-x^2-y^2)')
plt.xticks(np.arange(-2,2,step=0.5))
plt.yticks(np.arange(-2,2,step=0.5))
ax.tick_params(axis="x", labelsize=5)
ax.tick_params(axis="y", labelsize=5)
ax.tick_params(axis="z", labelsize=5)

plt.show()