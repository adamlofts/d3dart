
import 'dart:math' as Math;
import 'package:d3dart/D3Dart.dart' as d3;

void main() {
  var margin = {"top": 20, "right": 20, "bottom": 30, "left": 40},
      width = 960 - margin["left"] - margin["right"],
      height = 500 - margin["top"] - margin["bottom"];
  
  var y = new d3.LinearScale(range: [height, 0]);
  
  //var formatPercent = d3.format(".0%");
  
  d3.Ordinal x = new d3.Ordinal();
  x.rangeRoundBands([0, width], padding: 0.1);
  /**
   * var formatPercent = d3.format(".0%");

var x = d3.scale.ordinal()
    .rangeRoundBands([0, width], .1);

var y = d3.scale.linear()
    .range([height, 0]);

var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .tickFormat(formatPercent);
    
   */
  
  /*
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
  */
  
  var svg = d3.select("body").append("svg");
  
  svg.attr("width", width + margin["left"] + margin["right"]);
  svg.attr("height", height + margin["top"] + margin["bottom"]);
  svg = svg.append("g");
  svg.attr("transform", "translate(${margin["left"]},${margin["top"]})");
  
  d3.tsv("bar.tsv").then((List data) {
    x.domain = data.map((Map d) => d["letter"]).toList();
    /*
  y.domain([0, d3.max(data, function(d) { return d.frequency; })]);
     */
    print(data);
    
    var rect = svg.selectAll(".bar")
      .data(data)
    .enter.append("rect");
    
    rect.attr("class", "bar");
    
    rect.attrFunc("x", (d,i) => x((d as Map)["letter"]));
    rect.attrFunc("width", (d,i) => x.rangeBand);
    
    rect.attrFunc("y", (d,i) => /* y( */ (d as Map)["frequency"]);
    rect.attrFunc("height", (d,i) => height - (d as Map)["frequency"]);

    //rect.attr("height", function(d) { return height - y(d.frequency); });
    
  });
  
  return;
  /*
   * 

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Frequency");

  svg.selectAll(".bar")
      .data(data)
    .enter().append("rect")
      .attr("class", "bar")
      .attr("x", function(d) { return x(d.letter); })
      .attr("width", x.rangeBand())
      .attr("y", function(d) { return y(d.frequency); })
      .attr("height", function(d) { return height - y(d.frequency); });

});

  d3.csv("pie.csv").then((List data) {
    data.forEach((Map d) {
      d["population"] = double.parse(d["population"]);
    });
  
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
  */
}

/*
<script src="http://d3js.org/d3.v3.min.js"></script>
<script>


var svg = d3.select("body").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

d3.tsv("data.tsv", type, function(error, data) {
  x.domain(data.map(function(d) { return d.letter; }));
  y.domain([0, d3.max(data, function(d) { return d.frequency; })]);

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Frequency");

  svg.selectAll(".bar")
      .data(data)
    .enter().append("rect")
      .attr("class", "bar")
      .attr("x", function(d) { return x(d.letter); })
      .attr("width", x.rangeBand())
      .attr("y", function(d) { return y(d.frequency); })
      .attr("height", function(d) { return height - y(d.frequency); });

});

function type(d) {
  d.frequency = +d.frequency;
  return d;
}

</script>

*/
