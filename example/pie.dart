
import 'dart:math' as Math;
import 'package:d3dart/D3Dart.dart' as d3;

void main() {
  num width = 960,
      height = 500,
      radius = Math.min(width, height) / 2;

  d3.Ordinal color = new d3.Ordinal();
  color.range = ["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"];
  
  d3.Arc arc = new d3.Arc();
  arc.outerRadiusConst = radius - 10;
  arc.innerRadiusConst = 0;
  
  d3.Selection svg = d3.select("body").append("svg")
    ..attr("width", width)
    ..attr("height", height);
  
  svg = svg.append("g");
  svg.attr("transform", "translate(${width / 2},${height / 2})");
  
  var pie = d3.Layout.pie();
  pie.value = (Map d) => d["population"];
  
  d3.csv("pie.csv").then((List data) {
    var g = svg.selectAll(".arc")
        .data(pie(data))
        .enter.append("g");
    
    g.attr("class", "arc");
    
    var path = g.append("path");
    path.attrFunc("d", arc);
    path.style.fill = (Object d, int i) => color((d as Map)["data"]["age"]).toString();
  
    var text = g.append("text");
    text.attrFunc("transform", (Object d, int i) => "translate(${ arc.centroid(d, i).join(",") })");
    text.attr("dy", ".35em");
    
    text.style.textAnchor = (d, i) => "middle";
    text.textFunc = (d, i) => d["data"]["age"];
  });
}
