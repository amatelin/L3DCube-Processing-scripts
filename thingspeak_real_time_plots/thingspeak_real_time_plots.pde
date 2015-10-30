import http.requests.*;
import L3D.*;


// First set-up the request url
GetRequest get;
String channelId = "53833"; // id of the thingspeak channel to connect to
String requestParams = "?average=240&days=2"; // retrieve the average values over 4h periods
String requestStart = "https://api.thingspeak.com/channels/";
String requestEnd = "/feeds.json/";

String request = requestStart + channelId + requestEnd + requestParams;
String response;

// Set-up parameters for the plots
int[][] metadata = {{15, 25}, {30, 40}, {1000, 1050}, {0, 80}}; // lower and upper range of the data series. Used to map original values on 8 voxels
String[] fields = {"field1", "field2", "field3", "field4"}; // name of the fields to retrieve from json
color[] colors = {color(227, 131, 5), color(75, 97, 222), color(23, 181, 14), color(236, 242, 44)}; // colors to be used to display the series

// Instanciate cube object
L3D cube;

int nextUpdate = 0;
int updateRate = 4; // update rate in hours. Since the each data point is an average over 4h, update every 4h

void setup() {
  size(displayWidth, displayHeight, P3D);  // start simulation with 3d mode enabled
  cube = new L3D(this); // init cube 
  cube.enableMulticastStreaming(2000); // enable streaming of voxel colors
}

void draw() {
  // Adjustements so that the simulation fits my display properly
  scale(3);
  translate(-650, -350, 0);
  background(0);
  lights();
  
  if ((millis()-nextUpdate)>0) {
    updateData();
    nextUpdate = millis() + updateRate*60*60;
  }
}

void updateData() {
  JSONArray results = getData(); // retrieve data
  int k = results.size();
  int x = 7;
  
  // Display data as scatter plot mapped on 8 voxels
  // only the 8 last data points are displayed
  for (int i=0; i<8; i++) {
    for (int j=0; j<4; j++) {
      float value = results.getJSONObject(k-i-1).getFloat(fields[j]);
      int roundedValue = round(map(value, metadata[j][0], metadata[j][1], 0, 7));
      cube.setVoxel(x,roundedValue,j*2,colors[j]);
      cube.setVoxel(x,roundedValue,(j*2)+1,colors[j]); // We give a 2 voxel thickness to each data point
    }
    x--;
  }  
}

JSONArray getData() {
  JSONObject jsonObject;
  JSONArray results;
  
  get = new GetRequest(request); 
  get.send(); // send GET request to thingspeak
  response = get.getContent(); // retrieve response 
  jsonObject = parseJSONObject(response); // parse response
  results = jsonObject.getJSONArray("feeds"); // get data from response as Array
  
  return results;
}