import http.requests.*;
import L3D.*;

GetRequest get;
Table table;
String API_KEY = "3a95483c6a080fe9738e3308fd66c909";
String requestStart = "http://api.openweathermap.org/data/2.5/group?id=";
String requestEnd = "&units=metric&appid=" + API_KEY;
String subQueries[] = {"", ""};
String request;
String response;

JSONObject json;
JSONArray results;
color[] colors = new color[194];

L3D cube;
int radius = 4;
PVector center;
PVector[] polarCoord = new PVector[194];
PVector[] cartesCoord = new PVector[194];


void setup() {
  table = loadTable("openweathermap_cities.csv", "header");

  int i = 0;
  for (TableRow row : table.rows()) {
    
    polarCoord[i] = new PVector(row.getFloat("lat"), row.getFloat("long"));
    println(i);

    if (i<100) {
      subQueries[0] += row.getInt("api_id") + ",";
    } else {
      subQueries[1] += row.getInt("api_id") + ",";
    }
    
    i++;
  }
  
  for (int j=0; j<2; j++){
    request = requestStart + subQueries[j] + requestEnd;
    get = new GetRequest(request);
    get.send();
    response = get.getContent();
    JSONObject jsonObject = parseJSONObject(response);
    results = jsonObject.getJSONArray("list");
    for (int k=0; k<results.size(); k++) {
      println(k);
      float temperature = results.getJSONObject(k).getJSONObject("main").getFloat("temp");
      colors[k+(j*100)] = processColor(temperature);
    }
  }

  size(displayWidth, displayHeight, P3D);
  cube = new L3D(this);
  //cube.enableMulticastStreaming(2000);
  
  processCoordinates(radius);
  plotCoordinates();

}


void draw() {
  scale(3);
  translate(-650, -350, 0);
  background(0);
  lights();
}

color processColor(float value) {
  color c1 = color(99,184, 255);
  color c2 = color(255, 97,3);
  int maxTemp = 80;
  int minTemp = -40;
  float inter = map(value, minTemp, maxTemp, 0, 1);
   
  color c = lerpColor(c1, c2, inter);
   
  return c;
}

void plotCoordinates() {
  for (int i=0; i<cartesCoord.length; i++) {
    try {
      cube.setVoxel(cartesCoord[i], colors[i]);
    } catch(NullPointerException e) {
    
    }; 
  }
}

void processCoordinates(int radius) {
  println(polarCoord.length);
  for (int i=0; i<polarCoord.length; i++) {
    println(i);
    cartesCoord[i] = projectCoordinates(polarCoord[i].x, polarCoord[i].y, radius);
  }
}

PVector projectCoordinates(float latitude, float longitude, float r) {
  float theta = (latitude*PI)/180;
  float phi = (longitude*PI)/180;
  float x = (cos(phi)*cos(theta)*r)+4;
  float y = (sin(phi)*cos(theta)*r)+4;
  float z = (sin(theta)*r)+4;
  
  return new PVector(floor(x), floor(y), floor(z));
}