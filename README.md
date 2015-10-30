# L3DCube-Processing-scripts
Scripts used to visualize data on the L3D cube using processing as a back-end

##Table of contents
### Earth weather data visualization
[Folder](https://github.com/amatelin/L3DCube-Processing-scripts/tree/master/earth_weather_data)

This script uses the [openweathermap](http://openweathermap.org/api) API to retrieve the temperature from cities around the world and displays the result on the cube. 
The result is a "real-time" (actually the free API key only gives access to hourly updates) visualization of the earth's weather. 

A [Python script](https://github.com/amatelin/L3DCube-Processing-scripts/blob/master/earth_weather_data/py/city_coordinates_comparison.py) is used to select which cities are displayed: we start with a [json file](http://bulk.openweathermap.org/sample/) provided by openweathermap
that contains every city accessible from the API as well as their ID and coordinates. The json is parsed and casted as a panda dataframe. 
The latitude and longitude of each city are transormed in voxel coordinates over a sphere of 4 voxel radius. The cities that fall
on the same voxel are grouped and a random one is picked up from each group to represent that voxel. 

The result is saved in a csv file that is loaded in Processing and used to query the API. The temperatures of each city are then shown 
on the cube using a gradient of color. 

**TODO**:
* Choose better colors for gradient. 
* Add rotation animation. 
* Add auto update of temperatures. 
* Maybe switch to [wunderground](http://www.wunderground.com) API (better update rate). 

### Webcam stream projection
[Folder](https://github.com/amatelin/L3DCube-Processing-scripts/tree/master/pixelate_video_stream)
The video stream's frames are divided into 8x8 squares of equal surface. The color of the central pixel of each square is extracted 
and pushed into an array. The array's values are used to recompose the frame on the cube. 

With **enable3d** option set to true, the past 7 frames are stored and displayed on the back frames of the cube with a delay set by the 
variable **updateFrameRate**. 

The webcam stream could easily be substituted for any video stream if need be. 

**TODO**:
* Use average color over the surface of each input square instead of the central pixel value. 

### UDP stream client
[Folder](https://github.com/amatelin/L3DCube-Processing-scripts/tree/master/udp-stream-client)

Code that needs to be flashed on the Particle controlling the L3D cube to receive the pixel's values from Processing over UDP socket connection. 
The port of the sketch needs to match the one from the Processing script broadcasting. 

## Future visualizations:

* Kinect 3d video projection.
* Brain wave patterns (using openBCI or Muse headset). 
