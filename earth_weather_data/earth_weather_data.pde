import http.requests.*;
import L3D.*;

GetRequest get;
String API_KEY = "3a95483c6a080fe9738e3308fd66c909";
String requestStart = "http://api.openweathermap.org/data/2.5/group?id=";
String requestEnd = "&units=metric&appid=" + API_KEY;
String subQueries[] = {"", ""};
String request;
String response;

Table table;
JSONObject json;
JSONArray results;
color[] colors = new color[194];

L3D cube;
int radius = 4;
PVector center;
PVector[] polarCoord = new PVector[194];
PVector[] cartesCoord = new PVector[194];

int dataUpdateRate = 60; // rate at which to update data in mn
int rotationRate = 2; // rate at which to rotate the sphere in seconds
long nextDataUpdate = 0;
long nextRotation = 0;
int rotationAngle = 0;


void setup() {
  table = loadTable("openweathermap_cities.csv", "header");
  size(displayWidth, displayHeight, P3D);
  cube = new L3D(this);
  cube.enableMulticastStreaming(2000);
  
}


void draw() {
  scale(3);
  translate(-650, -350, 0);
  background(0);
  lights();
  
  if (millis() > nextDataUpdate ) {
    getData();
    nextDataUpdate = millis() + dataUpdateRate*60*60*1000;
  }
  
  if (millis() > nextRotation ) {
    processCoordinates(radius, rotationAngle);
    plotCoordinates();
    
    rotationAngle += 45;
    if (rotationAngle > 360) {
      rotationAngle = 0;
    }
    nextRotation = millis() + (rotationRate * 1000);
  }
}

color processColor(float value) {
  color c1 = color(0,145, 255); // color for cold temperatures
  color c2 = color(255, 94, 0); // color for warm temperatures
  int maxTemp = 45;
  int minTemp = -30;
  float inter = map(value, minTemp, maxTemp, 0, 1);
   
  color c = lerpColor(c1, c2, inter);
   
  return c;
}

void plotCoordinates() {
  cube.background(0); // clear cube voxels
  
  for (int i=0; i<cartesCoord.length; i++) {
    try {
      cube.setVoxel(cartesCoord[i], colors[i]);
    } catch(NullPointerException e) {
    
    }; 
  }
}

void processCoordinates(int radius, int rotation) {
  for (int i=0; i<polarCoord.length; i++) {
    cartesCoord[i] = projectCoordinates(polarCoord[i].x, polarCoord[i].y, radius, rotation);
  }
}

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