
import 'package:d3dart/D3Dart.dart' as d3;

void main() {
  var margin = {"top": 20, "right": 20, "bottom": 30, "left": 40},
      width = 960 - margin["left"] - margin["right"],
      height = 500 - margin["top"] - margin["bottom"];
  
  //var formatPercent = d3.format(".0%");
  
  d3.Ordinal x = new d3.Ordinal();
  x.rangeRoundBands([0, width], padding: 0.1);
  
  d3.LinearScale y = new d3.LinearScale();
  y.range = [height, 0];
  
  d3.Axis xAxis = new d3.Axis();
  xAxis.scale = x;
  xAxis.orient = "bottom";
  
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
  
  var svg = d3.select("body").append("svg");
  
  svg.attr("width", width + margin["left"] + margin["right"]);
  svg.attr("height", height + margin["top"] + margin["bottom"]);
  svg = svg.append("g");
  svg.attr("transform", "translate(${margin["left"]},${margin["top"]})");
  
  d3.tsv("bar.tsv").then((List data) {
    x.domain = data.map((Map d) => d["letter"]).toList();
    y.domain = [0, d3.max(data, f: (d) => d["frequency"])];
    
    var rect = svg.selectAll(".bar")
      .data(data)
    .enter.append("rect");
    
    rect.attr("class", "bar");
    
    rect.attrFunc("x", (d,i) => x((d as Map)["letter"]));
    rect.attrFunc("width", (d,i) => x.rangeBand);
    
   // .attr("y", function(d) { return y(d.frequency); })
   //   .attr("height", function(d) { return height - y(d.frequency); });
    
    rect.attrFunc("y", (d,i) => y((d as Map)["frequency"]));
    rect.attrFunc("height", (d,i) => height - y((d as Map)["frequency"]));

    //rect.attr("height", function(d) { return height - y(d.frequency); });
    
    var xaxis = svg.append("g");
    xaxis.attr("class", "x axis");
    xaxis.attr("transform", "translate(0,${height})");
    xaxis.call(xAxis);
  });
}

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
