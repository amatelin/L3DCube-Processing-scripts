import http.requests.*;

GetRequest get;
String[] queryElements = {"Bernie sanders", "Hillary clinton"};
String query;
String requestStart = "http://www.google.com/trends/fetchComponent?q=";
String requestEnd = "&date=now%201-H&cid=TIMESERIES_GRAPH_0&export=3";
String request;

void setup() {
  for (int i=0; i<queryElements.length; i++) {
    query+= queryElements[i] + ",";
  }
  println(query);
  get = new GetRequest("");
}

void draw() {
  //get.send();
  //get.getContent();
}