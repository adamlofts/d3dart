
import 'dart:math' as Math;
import 'dart:html';
import 'package:d3dart/D3Dart.dart' as d3;

void main() {
  
  num width = 960,
      height = 700,
      radius = Math.min(width, height) / 2;

  Function color = d3.Scale.category20c;
  
  d3.Selection svg = d3.select("body").append("svg")
    ..attr("width", width)
    ..attr("height", height);
  
  svg = svg.append("g");
  svg.attr("transform", "translate(${width / 2},${height * .52})");

  var partition = d3.Layout.partition();
  partition.size = [2 * Math.PI, radius * radius];
  partition.value = (Object d, int depth) => 1;
  //     .sort(null)

  d3.Arc arc = new d3.Arc();
  arc.startAngle = (Object d, int i) => (d as Map)["x"];
  arc.endAngle = (Object d, int i) => (d as Map)["x"] + (d as Map)["dx"];
  arc.innerRadius = (Object d, int i) => Math.sqrt((d as Map)["y"]);
  arc.outerRadius = (Object d, int i) => Math.sqrt((d as Map)["y"] + (d as Map)["dy"]);
  
  d3.json("flare.json").then((Object root) {
    svg.datum = root;
    var path = svg.selectAll("path").dataFunc(partition.nodes);
    var append = path.enter.append("path");
    
    append.attrFunc("display", (d, i) { // hide inner ring
      if (d["depth"] > 0) {
        return "";
      }
      return "none";
    });
    
    append.attrFunc("d", arc);
    append.style.stroke = (d, i) => "#FFF";
    append.style.fill = (d, i) => "#000";
    append.style.fillRule = (d, i) => "evenodd";
    
    //.style("fill", function(d) { return color((d.children ? d : d.parent).name); })

    /*
     * .style("fill-rule", "evenodd")
      .each(stash);
     */
    
  });
  
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
