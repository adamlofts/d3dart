
import 'dart:math' as Math;
import 'dart:html';
import 'package:d3dart/D3Dart.dart' as d3;

void main() {
  
  var margin = {"top": 40, "right": 10, "bottom": 10, "left": 10},
      width = 960 - margin["left"] - margin["right"],
      height = 500 - margin["top"] - margin["bottom"];

  var color = d3.Scale.category20c;

  var treemap = new d3.TreemapLayout();
  treemap.size = [width, height];
  treemap.sticky = true;
  treemap.value = (d, i) => d["size"];
  // fixme: treemap.sort != null
  
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
  };
  
  d3.json("flare.json").then((Object root) {
    div.datum = root;
    
    var node = div.selectAll(".node").dataFunc(treemap.nodes).enter.append("div");
    node.attr("class", "node");
    node.call(position);
    node.style.backgroundColor = (d, i) => (d["children"] != null) ? d3.colorToHex(color(d["name"])) : null;
    node.textFunc = (d, i) => (d["children"] != null) ? null : d["name"];

    for (Element $input in querySelectorAll("input")) {
      $input.onChange.listen((Event evt) {
        var value;
        
        if ((evt.target as InputElement).value == "count") {
          value = (d, i) => 1;
        } else {
          value = (d, i) => d["size"];
        }
        
        treemap.value = value;
        node
        .dataFunc(treemap.nodes)
            .call(position);
      });
    }
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
