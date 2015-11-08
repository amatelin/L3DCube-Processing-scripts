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
* Maybe switch to [wunderground](http://www.wunderground.com) API (better update rate). 

### Webcam stream projection
[Folder](https://github.com/amatelin/L3DCube-Processing-scripts/tree/master/pixelate_video_stream)

The video stream's frames are divided into 8x8 squares of equal surface. The average RGB values of every pixel in the square is extracted and used to recompose a smaller image. The image is then projected on to the cube.

With enable3d option set to true, the past 7 frames are stored and displayed on the back frames of the cube with a delay set by the variable updateFrameRate.

The webcam stream could easily be substituted for any video stream if need be. 

**TODO**:
* Maybe increase contrast of output colors

### Real time scatter plots
[Folder](https://github.com/amatelin/L3DCube-Processing-scripts/tree/master/thingspeak_real_time_plots)

Demonstration of the plotting capabilites of the cube. Data is retrieved from a public [thingspeak channel](https://thingspeak.com/channels/53833) (they correspond to 
data points posted by a connected barometer installed in my living room). 
The json returned by the thingspeak api is parsed on processing and displayed on the cube. Each serie of data is represented by a 2 voxels thick scatter plot. 

The client code on the photon is a variation of the main client: we use the accelerometer data to give the ability to change the plot displayed on the front frames of the cube. 

### Kinect depth and color projection
[Folder](https://github.com/amatelin/L3DCube-Processing-scripts/tree/master/kinect_3d_visualization)

The kinect is a traditional camera doubled with an Infra Red Camera, enabling it to perceive depth in addition to the color information.

Originally sold for Xbox, it is now available for PCs under the brand Kinect for Windows. Don't let the name fool you, it will work just as well on OSX or Linux. 

Similarly to what we did for the webcam, we connect to the video stream of the kinect, analyze each frame and downsize them so that they can be displayed on the cube's 8*8 resolution. 

But this time, we will also extract the depth information that the kinect returns along with the color information of every pixel. In the same way that we averaged the RGB values to recompose a smaller output image, we will compute the average depth of each new pixel. This depth will be used to position the voxels on the z axis of the cube.  

### UDP stream client
[Folder](https://github.com/amatelin/L3DCube-Processing-scripts/tree/master/udp-stream-client)

Code that needs to be flashed on the Particle controlling the L3D cube to receive the pixel's values from Processing over UDP socket connection. 
The port of the sketch needs to match the one from the Processing script broadcasting. 

## Future visualizations:

* Brain wave patterns (using openBCI or Muse headset). 
