import http.requests.*;
import L3D.*;

// First set-up the request parameters and url
GetRequest get;
String API_KEY = "YOUR_API_KEY"; // Your OpenWeatherMap API key to authenticate your requests
String requestStart = "http://api.openweathermap.org/data/2.5/group?id="; // base url for group requests
String requestEnd = "&units=metric&appid=" + API_KEY; // request arguments
// used to store the ids of the cities that we will query. 
// there are two strings because we will pass 2 requests
// (a group call is limited to 100 ids/call which is why we need to pass 2)
String subQueries[] = {"", ""}; 
String request;
String response;

Table table; // will store the csv info
JSONArray results; // will store the result of the query
color[] colors = new color[194]; // will store the colors corresponding to each city's temperature

// Instanciate cube object
L3D cube;

// variables used to transform polar coordinates into cartesian ones
int radius = 4; // radius of the output sphere in voxel
PVector center;
PVector[] polarCoord = new PVector[194];
PVector[] cartesCoord = new PVector[194];

int dataUpdateRate = 60; // rate at which to update data in mn
int rotationRate = 2; // rate at which to rotate the sphere in seconds

// used to keep track of events
long nextDataUpdate = 0;
long nextRotation = 0;
int rotationAngle = 0;


void setup() {
  size(512, 512, P3D);  // start simulation with 3d renderer
  table = loadTable("openweathermap_cities.csv", "header");

  cube = new L3D(this);
  cube.enableMulticastStreaming(2000);
  
}

void draw() {
  background(0); // set background to black
  lights(); // turn on light
  
  // update data if delay elapsed
  if (millis() > nextDataUpdate ) {
    getData();
    nextDataUpdate = millis() + dataUpdateRate*60*60*1000; // reset time for next update
  }

  // rotate sphere if delay elapsed
  if (millis() > nextRotation ) {
    processCoordinates(radius, rotationAngle); // re-process coordinates according to new rotation angle
    plotCoordinates(); // send new coordinates to the cube
    
    rotationAngle += 45; // update rotation angle, resetting to 0 if greater than 360 degrees
    if (rotationAngle > 360) {
      rotationAngle = 0;
    }
    nextRotation = millis() + (rotationRate * 1000); // reset time for next rotation
  }
}

/*
* Return a color according to the position of the temperature
* over a pre-defined range
*/
color processColor(float value) {
  color c1 = color(0,145, 255); // color for cold temperatures
  color c2 = color(255, 94, 0); // color for warm temperatures
  // set temperature range used to map a value to a color 
  int maxTemp = 45; 
  int minTemp = -30;
  
  // map temperature value between [0 ; 1]
  float inter = map(value, minTemp, maxTemp, 0, 1);
  
  // map the value to a color
  color c = lerpColor(c1, c2, inter);
   
  return c;
}

/*
* Light up the voxels according to the colors and 
* coordinates stored in colors[] and cartesCoord[]
*/
void plotCoordinates() {
  cube.background(0); // clear cube voxels
  
  for (int i=0; i<cartesCoord.length; i++) {
    try {
      cube.setVoxel(cartesCoord[i], colors[i]);
    } catch(NullPointerException e) {
    
    }; 
  }
}

/*
*  Transform the polar coordinates stored in polarCoord[]
* in cartesian ones and store the result in cartesCoord[]
*/
void processCoordinates(int radius, int rotation) {
  for (int i=0; i<polarCoord.length; i++) {
    cartesCoord[i] = projectCoordinates(polarCoord[i].x, polarCoord[i].y, radius, rotation);
  }
}

/*
* Transform polar coordinates (lat, long) into cartesian (x, y, z).
* Option: a rotation can be applied to the referencial
*/
PVector projectCoordinates(float latitude, float longitude, float r, int rotation) {
  // convert degrees in radians
  float theta = (latitude*PI)/180;
  float phi = (longitude*PI)/180;
  float rad = (rotation*PI)/180;

  // transform polar coordinates into cartesian ones 
  float x = (sin(phi)*cos(theta)*r);
  float y = (sin(theta)*r)+4;
  float z = (cos(phi)*cos(theta)*r);
  
  // apply rotation
  float x_p = x*cos(rad) + z*sin(rad) + 4;
  float z_p = -sin(rad)*x + cos(rad)*z + 4;
  
  return new PVector(floor(x_p), floor(y), floor(z_p));
}

/*
* Query the OpenWeatherMap API and parse the result
*/
void getData() {
  int i = 0;
  for (TableRow row : table.rows()) {   
    polarCoord[i] = new PVector(row.getFloat("lat"), row.getFloat("long"));

    // Create query
    if (i<100) {
      subQueries[0] += row.getInt("api_id") + ",";
    } else {
      subQueries[1] += row.getInt("api_id") + ",";
    }
    i++;
  }
  
  // Two requests are made because results are limited at 100 per query (we need 200)s
  for (int j=0; j<2; j++){
    // Make request
    request = requestStart + subQueries[j] + requestEnd;
    get = new GetRequest(request);
    get.send();
    response = get.getContent();
    
    // Parse result
    JSONObject jsonObject = parseJSONObject(response);
    results = jsonObject.getJSONArray("list");
    for (int k=0; k<results.size(); k++) {
      float temperature = results.getJSONObject(k).getJSONObject("main").getFloat("temp");
      colors[k+(j*100)] = processColor(temperature); // Get color from temperature value
    }
  }
}