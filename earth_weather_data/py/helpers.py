import numpy as np

## Function used to compute cartesian coordinates for polar ones
def toCartesian(lat, long, radius, **kwargs):
    # the offset is used to alter the center of the sphere
    # we assume that offset_x = offset_y = offset_z
    if kwargs.get("offset"):
        offset = kwargs.get("offset")
    else:
        offset = 0

    # convert angles from degrees to radians
    phi = (long*np.pi)/180
    theta = (lat*np.pi)/180
    
    # compute values
    x = (radius*np.cos(phi)*np.cos(theta)) + offset
    y = (radius*np.sin(phi)*np.cos(theta)) + offset
    z = (radius*np.sin(theta)) + offset
    
    return x, y, z

## Rounds values, analog to what is done to get the Voxel values on the cube
def testPoint(lat, long, radius, **kwargs):
    x, y, z = toCartesian(lat, long, radius, **kwargs)
    return x, int(round(x)), y, int(round(y)), z, int(round(z))