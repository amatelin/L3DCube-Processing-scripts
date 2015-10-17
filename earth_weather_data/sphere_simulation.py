from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy as np

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

u = np.linspace(0, 2 * np.pi, 100)
v = np.linspace(0, np.pi, 100)

"""x = 10 * np.outer(np.cos(u), np.sin(v))
y = 10 * np.outer(np.sin(u), np.sin(v))
z = 10 * np.outer(np.ones(np.size(u)), np.cos(v))"""
r=1
phi, theta = np.mgrid[0.0:np.pi:100j, 0.0:2.0*np.pi:100j]
x = r*np.sin(phi)*np.cos(theta)
y = r*np.sin(phi)*np.sin(theta)
z = r*np.cos(phi)
#ax.plot_surface(x, y, z,  rstride=4, cstride=4, color='b')

def addPoint(lat, long, color):
    phi = (lat*np.pi)/180
    theta = (long*np.pi)/180
    x = r*np.cos(phi)*np.sin(theta)
    y = r*np.sin(phi)*np.sin(theta)
    z = r*np.cos(theta)
    ax.scatter(x, y, z, color=color, s=50*np.pi)
    
addPoint(40.4000,3.7167, "black") # Madrid
addPoint(48.8567,2.3508, "red") # Paris
addPoint(51.507222,-0.1275, "blue") # London
addPoint(40.7127,-74.0059, "green") # NYC
addPoint(34.05,-118.25, "yellow") # LA
addPoint(45.5017,73.5673, "yellow") # Montreal
    
plt.show()