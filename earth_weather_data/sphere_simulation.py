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
ax.plot_surface(x, y, z,  rstride=4, cstride=4, color='b', alpha=0.1)

def addPoint(lat, long, color):
    phi = (long*np.pi)/180
    theta = (lat*np.pi)/180
    x = (r*np.cos(phi)*np.cos(theta))
    y = (r*np.sin(phi)*np.cos(theta))
    z = (r*np.sin(theta))
    print("x:{0}, y:{1}, z:{2}".format(x, y, z))
    print("x:{0}, y:{1}, z:{2}".format(round(x), round(y), round(z)))
    ax.scatter(x, y, z, color=color, s=50*np.pi)
    
addPoint(40.4000,-3.7167, "black") # Madrid
addPoint(48.8567,2.3508, "red") # Paris
addPoint(51.507222,-0.1275, "blue") # London
addPoint(40.7127,-74.0059, "green") # NYC
addPoint(34.05,-118.25, "yellow") # LA
addPoint(45.5017,-73.5673, "yellow") # Montreal
    
plt.show()



##Testing how distance affects result 
r = 4
def testPoint(lat, long):
    phi = (long*np.pi)/180
    theta = (lat*np.pi)/180
    x = (r*np.cos(phi)*np.cos(theta))+4
    y = (r*np.sin(phi)*np.cos(theta))+4
    z = (r*np.sin(theta))+4
    print("x:{0}, y:{1}, z:{2}".format(x, y, z))
    print("x:{0}, y:{1}, z:{2}".format(round(x), round(y), round(z)))
    return x, round(x)

raw = []
rounded = []

# how latitude variation affects x
for i in range(-180, 181):
    x, r_x = testPoint(i, 0)
    raw.append(x)
    rounded.append(r_x)
    
    
# evenly sampled time at 200ms intervals
x = np.arange(-180, 181, 1)

# red dashes, blue squares and green triangles
plt.plot(x, raw, 'r--', x, rounded, 'bs')
plt.show()

plt.plot()