
import 'package:d3dart/D3Dart.dart' as d3;

void main() {
  var margin = {"top": 20, "right": 20, "bottom": 30, "left": 40},
      width = 960 - margin["left"] - margin["right"],
      height = 500 - margin["top"] - margin["bottom"];
  
  var x = new d3.LinearScale();
  x.range = [0, width];

  var y = new d3.LinearScale();
  y.range = [height, 0];

  var color = d3.Scale.category10;
  
  var xAxis = new d3.Axis();
  xAxis.scale = x;
  xAxis.orient = "bottom";
  xAxis.tickFormat = (num d, i) => d.toStringAsFixed(1);
  
  var yAxis = new d3.Axis();
  yAxis.scale = y;
  yAxis.orient = "left";
  
  var svg = d3.select("body").append("svg");
  svg.attr("width", width + margin["left"] + margin["right"]);
  svg.attr("height", height + margin["top"] + margin["bottom"]);
  
  svg = svg.append("g");
  svg.attr("transform", "translate(${margin["left"]},${margin["top"]})");
  
  d3.tsv("scatterplot.tsv").then((List data) {
    //data.forEach((d) {
    //  d.sepalLength = +d.sepalLength;
    //  d.sepalWidth = +d.sepalWidth;
    //});
  
    x.domain = d3.extent(data, (d, i) => d["sepalWidth"]);
    x.nice();
    y.domain = d3.extent(data, (d, i) => d["sepalLength"]);//).nice();
    y.nice();
  
    var gX = svg.append("g");
    gX
      ..attr("class", "x axis")
      ..attr("transform", "translate(0,${height})")
      ..call(xAxis);
  
    var label = gX.append("text")
      ..attr("class", "label")
      ..attr("x", width)
      ..attr("y", -6);
    label.style.textAnchorConst = "end";
    label.text = "Sepal Width (cm)";
    
    var gY = svg.append("g");
    gY..attr("class", "y axis")
      ..call(yAxis);
    
    label = gY.append("text");
    label
      ..attr("class", "label")
      ..attr("transform", "rotate(-90)")
      ..attr("y", 6)
      ..attr("dy", ".71em");
    label.style.textAnchorConst = "end";
    label.text = "Sepal Length (cm)";
    
    var circle = svg.selectAll(".dot")
        .data(data)
      .enter.append("circle");
    
    circle
      ..attr("class", "dot")
      ..attr("r", 3.5)
      ..attrFunc("cx", (d, i) => x(d["sepalWidth"]))
      ..attrFunc("cy", (d, i) => y(d["sepalLength"]));

    circle.style.fill = (d, i) => colorToHex(color(d["species"]));
  
    var legend = svg.selectAll(".legend")
        .data(color.domain)
      .enter.append("g");
    
    legend
        ..attr("class", "legend")
        ..attrFunc("transform", (d, i) => "translate(0,${i * 20})");
  
    legend.append("rect")
        ..attr("x", width - 18)
        ..attr("width", 18)
        ..attr("height", 18)
        ..style.fill = (d, i) => colorToHex(color(d));
  
    var lt = legend.append("text")
        ..attr("x", width - 24)
        ..attr("y", 9)
        ..attr("dy", ".35em");
    
    lt.style.textAnchorConst = "end";
    lt.textFunc = (d, i) => d;
  });
}
