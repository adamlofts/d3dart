
import 'dart:math' as Math;
import 'dart:html';
import 'dart:svg';
import 'package:d3dart/D3Dart.dart' as d3;

void main() {
  
  num width = 960,
      height = 500,
      radius = Math.min(width, height) / 2;

  Function color = d3.Scale.ordinal()
      .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);
  
  d3.Arc arc = new d3.Arc();
  arc.outerRadius = radius - 10;
  arc.innerRadius = 0;
  arc.startAngle = 0;
  arc.endAngle = Math.PI * 2;
  
  d3.Selection svg = d3.select("body").append("svg")
    ..attr("width", width)
    ..attr("height", height);
  
  svg = svg.append("g");
  svg.attr("transform", "translate(${width / 2},${height / 2})");
  
  var pie = d3.Layout.pie([]);
  pie.value = (Map d) => d["population"];
  
  d3.csv("pie.csv").then((List data) {
    
    data.forEach((Map d) {
      d["population"] = double.parse(d["population"]);
    });
  
    var g = svg.selectAll(".arc")
        .data(pie(data))
        .enter.append("g");
    
    g.attr("class", "arc");
    
    var text = g.append("text");
    text.attrFunc("transform", (Object d, int i) => "translate(${ arc.centroid(d, i).join(",") })");
    text.attr("dy", ".35em");
    
    text.style.textAnchor = (d, i) => "middle";
    text.textFunc = (d, i) => d["data"]["age"];
    
    print(query("svg").children);
    print(query("svg").children.first.children);

    print(query("svg").children.first.attributes.keys);
    print(query("svg").children.first.attributes.values);
      
      //g.append("path")
      //  .attr("d", arc)
      //    .style("fill", function(d) { return color(d.data.age); });
    
    SvgSvgElement svg2 = new SvgSvgElement();
    query("body").append(svg2);
    
  });
  
  
  
  /*
   * 
   * <script src="http://d3js.org/d3.v3.min.js"></script>
<script>

var width = 960,
    height = 500,
    radius = Math.min(width, height) / 2;

var color = d3.scale.ordinal()
    .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);



var pie = d3.layout.pie()
    .sort(null)
    .value(function(d) { return d.population; });

var svg = d3.select("body").append("svg")
    .attr("width", width)
    .attr("height", height)
  .append("g")
    .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

d3.csv("data.csv", function(error, data) {

  data.forEach(function(d) {
    d.population = +d.population;
  });

  var g = svg.selectAll(".arc")
      .data(pie(data))
    .enter().append("g")
      .attr("class", "arc");

  g.append("path")
      .attr("d", arc)
      .style("fill", function(d) { return color(d.data.age); });

  g.append("text")
      .attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
      .attr("dy", ".35em")
      .style("text-anchor", "middle")
      .text(function(d) { return d.data.age; });

});

</script>
*/
  /*

var partition = d3.layout.partition()
    .sort(null)
    .size([2 * Math.PI, radius * radius])
    .value(function(d) { return 1; });
  
var arc = d3.svg.arc()
    .startAngle(function(d) { return d.x; })
    .endAngle(function(d) { return d.x + d.dx; })
    .innerRadius(function(d) { return Math.sqrt(d.y); })
    .outerRadius(function(d) { return Math.sqrt(d.y + d.dy); });

d3.json("flare.json", function(error, root) {
  var path = svg.datum(root).selectAll("path")
      .data(partition.nodes)
    .enter().append("path")
      .attr("display", function(d) { return d.depth ? null : "none"; }) // hide inner ring
      .attr("d", arc)
      .style("stroke", "#fff")
      .style("fill", function(d) { return color((d.children ? d : d.parent).name); })
      .style("fill-rule", "evenodd")
      .each(stash);

  d3.selectAll("input").on("change", function change() {
    var value = this.value === "count"
        ? function() { return 1; }
        : function(d) { return d.size; };

    path
        .data(partition.value(value).nodes)
      .transition()
        .duration(1500)
        .attrTween("d", arcTween);
  });
});

// Stash the old values for transition.
function stash(d) {
  d.x0 = d.x;
  d.dx0 = d.dx;
}

// Interpolate the arcs in data space.
function arcTween(a) {
  var i = d3.interpolate({x: a.x0, dx: a.dx0}, a);
  return function(t) {
    var b = i(t);
    a.x0 = b.x;
    a.dx0 = b.dx;
    return arc(b);
  };
}

d3.select(self.frameElement).style("height", height + "px");
*/
}
