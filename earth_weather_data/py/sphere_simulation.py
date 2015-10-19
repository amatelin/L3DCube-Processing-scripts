from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy as np
from helpers import toCartesian, testPoint
import pandas as pd


## Used to add a point to the sphere providing polar coordinates
def addPoint(lat, long, radius, color, **kwargs):
    x, y, z = toCartesian(lat, long, radius, **kwargs)
    ax.scatter(x, y, z, color=color, s=50*np.pi)
#    print("x:{0}, y:{1}, z:{2}".format(x, y, z))
#    print("x:{0}, y:{1}, z:{2}".format(round(x), round(y), round(z)))


# Generate sphere 3d graph
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

u = np.linspace(0, 2 * np.pi, 100)
v = np.linspace(0, np.pi, 100)

r=1

# Generate sphere coordinates
phi, theta = np.mgrid[0.0:np.pi:100j, 0.0:2.0*np.pi:100j]
x = r*np.sin(phi)*np.cos(theta)
y = r*np.sin(phi)*np.sin(theta)
z = r*np.cos(phi)
# Plot sphere
ax.plot_surface(x, y, z,  rstride=4, cstride=4, color='b', alpha=0.1)
    
# Add a few points
#addPoint(40.4000,-3.7167, r, "black") # Madrid
#addPoint(48.8567,2.3508, r, "red") # Paris
#addPoint(51.507222,-0.1275, r, "blue") # London
#addPoint(40.7127,-74.0059, r,"green") # NYC
#addPoint(34.05,-118.25, r,"yellow") # LA
#addPoint(45.5017,-73.5673, r, "pink") # Montreal

path = "C:/Users/amate_000/Google Drive/WearHacks/L3DCube/Code/L3DCube-Processing-scripts/earth_weather_data/data/world_capitals_processed.csv"
df = pd.read_csv(path, header=0, sep=",")

for i, row in df.iterrows():
    addPoint(row["lat"], row["long"], r, np.random.rand(3,1))


plt.show()



##Testing how distance affects result 
r = 4

# how latitude/longitude variation affects x
# for latitude put i in first position and 0 for 2nd
# for longitude put 0 in first position and long for 2nd
raw_x = []
rounded_x = []
raw_y = []
rounded_y = []
raw_z = []
rounded_z = []

for i in range(-180, 181):
    x, r_x, y, r_y, z, r_z = testPoint(i, 0, r, offset=4)
    raw_x.append(x)
    rounded_x.append(r_x)
    raw_y.append(y)
    rounded_y.append(r_y)    
    raw_z.append(z)
    rounded_z.append(r_z)
    
x = np.arange(-180, 181, 1)

plt.plot(x, raw_x, color="#0000FF", label="x")
plt.scatter(x, rounded_x, color="#58ACFA", marker="s", label="round(x)")
plt.plot(x, raw_y, color="#DF0101", label="y")
plt.scatter(x, rounded_y, color="#F78181", marker="s", label="round(y)")
plt.plot(x, raw_z, color="#DF01D7", label="z")
plt.scatter(x, rounded_z, color="#F5A9D0", marker="s", label="round(z)")

plt.xlabel("Latitude")
plt.legend(loc=2)
plt.show()



