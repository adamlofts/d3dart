
import 'dart:math' as Math;
import 'dart:html';
import 'package:d3dart/D3Dart.dart' as d3;

d3.Selection path;
var partition;
d3.Arc arc;

void main() {
  
  num width = 960,
      height = 700,
      radius = Math.min(width, height) / 2;

  d3.Ordinal color = d3.Scale.category20c;
  
  d3.Selection svg = d3.select("body").append("svg")
    ..attr("width", width)
    ..attr("height", height);
  
  svg = svg.append("g");
  svg.attr("transform", "translate(${width / 2},${height * .52})");

  partition = d3.Layout.partition();
  partition.size = [2 * Math.PI, radius * radius];
  partition.value = (Object d, int depth) => 1;
  //     .sort(null)

  arc = new d3.Arc();
  arc.startAngle = (Object d, int i) => (d as Map)["x"];
  arc.endAngle = (Object d, int i) => (d as Map)["x"] + (d as Map)["dx"];
  arc.innerRadius = (Object d, int i) => Math.sqrt((d as Map)["y"]);
  arc.outerRadius = (Object d, int i) => Math.sqrt((d as Map)["y"] + (d as Map)["dy"]);
  
  d3.json("flare.json").then((Object root) {
    svg.datum = root;
    var path1 = svg.selectAll("path").dataFunc(partition.nodes);
    path = path1.enter.append("path");
    
    path.attrFunc("display", (d, i) { // hide inner ring
      if (d["depth"] > 0) {
        return "";
      }
      return "none";
    });
    
    path.attrFunc("d", arc);
    path.style.stroke = (d, i) => "#FFF";
    path.style.fill = (Map d, i) {
      if ((d["children"] == null) || (d["children"].isEmpty)) {
        d = d["parent"];
      }
      return "#${color(d["name"]).toRadixString(16)}";
    };
    path.style.fillRule = (d, i) => "evenodd";
    

    /*
      .each(stash);
     */
    
    
    for (Element elmt in querySelectorAll("input")) {
      elmt.onChange.listen(onChange);
    }
  });
}

void onChange(Event evt) {
  var value;
  
  if ((evt.target as InputElement).value == "count") {
    value = (Object d, int depth) => 1;
  } else {
    value = (Object d, int depth) => (d as Map)["size"];
  }
  
  partition.value = value;
  d3.BoundSelection bound = path.dataFunc(partition.nodes);
  bound.attrFunc("d", arc);
  //bound.attrFunc("d", )
  
  return;
  /*
  var value = this.value === "count"
      ? function() { return 1; }
  : function(d) { return d.size; };

  path
  .data(partition.value(value).nodes)
    .transition()
      .duration(1500)
        .attrTween("d", arcTween);
        */
}
  /*

d3.json("flare.json", function(error, root) {

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
