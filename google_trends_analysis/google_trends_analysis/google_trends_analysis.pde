import http.requests.*;

GetRequest get;
String[] queryElements = {"Bernie%20sanders", "Hillary%20clinton"};
String query;
String requestStart = "http://www.google.com/trends/fetchComponent?q=";
String requestEnd = "&date=now%201-H&cid=TIMESERIES_GRAPH_0&export=3";
String request;

void setup() {
  query = "";
  request = "";
  
  for (int i=0; i<queryElements.length; i++) {
    query+= queryElements[i] + ",";
  }
  
  request += requestStart;
  request += query;
  request += requestEnd;
  
  get = new GetRequest(request);

}

void draw() {
  get.send();
  println(get.getContent());
}