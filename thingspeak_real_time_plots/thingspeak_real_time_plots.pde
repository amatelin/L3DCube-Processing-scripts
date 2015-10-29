import http.requests.*;
import L3D.*;

GetRequest get;
String requestStart = "https://api.thingspeak.com/channels/";
String requestEnd = "/feeds.json";
String channelId = "53833";
String request = requestStart + channelId + requestEnd;
String response;

int[][] data = new int[4][8];
int[][] metadata = {{15, 30}, {30, 40}, {1015, 1050}, {0, 90}};
String[] fields = {"field1", "field2", "field3", "field4"};
color[] colors = {color(227, 131, 5), color(75, 97, 222), color(23, 181, 14), color(236, 242, 44)};

JSONObject json;
JSONArray results;

L3D cube;

void setup() {
  size(displayWidth, displayHeight, P3D);
  cube = new L3D(this);
  
  get = new GetRequest(request);
  get.send();
  response = get.getContent();
  JSONObject jsonObject = parseJSONObject(response);
  results = jsonObject.getJSONArray("feeds");
  int k = results.size();
  print(results);
  print(k);
  
  for (int i=0; i<8; i++) {
    for (int j=0; j<4; j++) {
      float value = results.getJSONObject(k-i-1).getFloat(fields[j]);
      data[j][i] = round(map(value, metadata[j][0], metadata[j][1], 0, 7));
      println(data[j][i]);
      cube.setVoxel(i,data[j][i],j*2,colors[j]);
      cube.setVoxel(i,data[j][i],(j*2)+1,colors[j]);
      
    }
  }

  //print(results);
  
  


}



void draw() {
  scale(3);
  translate(-650, -350, 0);
  background(0);
  lights();
}