
import 'dart:math' as Math;
import 'dart:html';

import 'package:intl/intl.dart';

import 'package:d3dart/D3Dart.dart' as d3;

void main() {
  
  var margin = {"top": 20, "right": 20, "bottom": 30, "left": 50},
      width = 960 - margin["left"] - margin["right"],
      height = 500 - margin["top"] - margin["bottom"];
  
//  var parseDate = d3.time.format("%d-%b-%y").parse;
//  var x = d3.time.scale()
  
  var x = new d3.LinearScale();
  x.range = [width, 0];
  
  var xAxis = new d3.Axis();
  xAxis.scale = x;
  xAxis.orient = "bottom";
  
  var y = new d3.LinearScale();
  y.range = [height, 0];
  
  var yAxis = new d3.Axis();
  yAxis.scale = y;
  yAxis.orient = "left";
  
  var line = new d3.Line();
  line.x = (d, i) => x(d["date"]);
  line.y = (d, i) => y(d["close"]);
  
  var svg = d3.select("body").append("svg");
  svg.attr("width", width + margin["left"] + margin["right"]);
  svg.attr("height", height + margin["top"] + margin["bottom"]);

  var g = svg.append("g");
  g.attr("transform", "translate(${margin["left"]},${margin["top"]})");
  
  DateFormat df = new DateFormat("dd-MMM-yy", "en_US");
  
  d3.tsv("line.tsv").then((List data) {
    data.forEach((Map d) {
      d["date"] = df.parse(d["date"]).millisecondsSinceEpoch.abs();
//    d.date = parseDate(d.date);
//    d.close = +d.close;
  });

    x.domain = d3.extent(data, (d,i) { return d["date"]; });
    y.domain = d3.extent(data, (d,i) { return d["close"]; });
  
    var gx = g.append("g");
    gx.attr("class", "x axis");
    gx.attr("transform", "translate(0,${height})");
    gx.call(xAxis);
  
    var gy = g.append("g");
    gy.attr("class", "y axis");
    gy.call(yAxis);
    
    var gl = gy.append("text");
    gl.attr("transform", "rotate(-90)");
    gl.attr("y", 6);
    gl.attr("dy", ".71em");
    gl.style.textAnchorConst = "end";
    gl.text = "Price (\$)";
  
    var path = g.append("path");
    path.datum = data;
    path.attr("class", "line");
    path.attrFunc("d", line);
  });
}