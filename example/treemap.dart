
import 'dart:math' as Math;
import 'package:d3dart/D3Dart.dart' as d3;

/*
var div = d3.select("body").append("div")
    .style("position", "relative")
    .style("width", (width + margin.left + margin.right) + "px")
    .style("height", (height + margin.top + margin.bottom) + "px")
    .style("left", margin.left + "px")
    .style("top", margin.top + "px");

d3.json("flare.json", function(error, root) {
  var node = div.datum(root).selectAll(".node")
      .data(treemap.nodes)
    .enter().append("div")
      .attr("class", "node")
      .call(position)
      .style("background", function(d) { return d.children ? color(d.name) : null; })
      .text(function(d) { return d.children ? null : d.name; });

  d3.selectAll("input").on("change", function change() {
    var value = this.value === "count"
        ? function() { return 1; }
        : function(d) { return d.size; };

    node
        .data(treemap.value(value).nodes)
      .transition()
        .duration(1500)
        .call(position);
  });
});

function position() {
  this.style("left", function(d) { return d.x + "px"; })
      .style("top", function(d) { return d.y + "px"; })
      .style("width", function(d) { return Math.max(0, d.dx - 1) + "px"; })
      .style("height", function(d) { return Math.max(0, d.dy - 1) + "px"; });
}

</script>
*/

void main() {
  var margin = {"top": 40, "right": 10, "bottom": 10, "left": 10},
      width = 960 - margin["left"] - margin["right"],
      height = 500 - margin["top"] - margin["bottom"];

  var color = d3.Scale.category20c;

  var treemap = new d3.TreemapLayout();
  treemap.size = [width, height];
  treemap.sticky = true;
  treemap.value = (d, i) => d["size"];

  
  d3.Selection div = d3.select("body").append("div");
  div.style.positionConst = "relative";
  div.style.widthConst = "${width + margin["left"] + margin["right"]}px";
  div.style.heightConst = "${height + margin["top"] + margin["bottom"]}px";
  div.style.leftConst = "${margin["left"]}px";
  div.style.topConst = "${margin["top"]}px";
  
  var position = (nodes) {
    nodes.style.left = (d, i) => "${d["x"]}px";
    nodes.style.top = (d, i) => "${d["y"]}px";
    nodes.style.width = (d, i) => "${Math.max(0, d["dx"] - 1)}px";
    nodes.style.height = (d, i) => "${Math.max(0, d["dy"] - 1)}px";
    
    /*
    this.style("left", function(d) { return d.x + "px"; })
      .style("top", function(d) { return d.y + "px"; })
      .style("width", function(d) { return Math.max(0, d.dx - 1) + "px"; })
      .style("height", function(d) { return Math.max(0, d.dy - 1) + "px"; });
      */
  };
  
  d3.json("flare.json").then((Object root) {
    div.datum = root;
    
    var node = div.selectAll(".node").dataFunc(treemap.nodes).enter.append("div");
    node.attr("class", "node");
    node.call(position);
    node.style.backgroundColor = (d, i) => (d["children"] != null) ? "#${color(d["name"]).toRadixString(16)}" : null;
    node.textFunc = (d, i) => (d["children"] != null) ? null : d["name"];
    
/*
    d3.selectAll("input").on("change", function change() {
      var value = this.value === "count"
          ? function() { return 1; }
      : function(d) { return d.size; };

      node
      .data(treemap.value(value).nodes)
        .transition()
          .duration(1500)
            .call(position);
    });
    */
  });
}

  /*
  
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

    circle.style.fill = (d, i) => "#${color(d["species"]).toRadixString(16)}";
  
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
        ..style.fill = (d, i) => "#${color(d).toRadixString(16)}";
  
    var lt = legend.append("text")
        ..attr("x", width - 24)
        ..attr("y", 9)
        ..attr("dy", ".35em");
    
    lt.style.textAnchorConst = "end";
    lt.textFunc = (d, i) => d;
  });
  */
