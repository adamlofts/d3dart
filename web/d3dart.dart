
import 'dart:math' as Math;
import 'dart:html';
import 'package:d3dart/D3Dart.dart' as d3;

void main() {
  
  //d3.selectAll("p").style.color = (d,i) => (i % 2 == 0) ? "#f00" : "#0ff";
  //d3.select("body").style.backgroundColor = (d,i) => ("black");
  //d3.Selection selection = d3.select("body").selectAll("p");
  //selection.data([4, 8, 15, 16, 23, 42]).style.fontSize = (d, i) => "${d}px";
  
  //d3.EnterSelection esel = selection.enter();
  //esel.append("p");
  //esel.text = (d, i) => "d=${d} i=${i}";
  
  //var circle = svg.selectAll("circle");
  
  Map<Element, Object> m = {};
  var b1 = query("h1");
  var b2 = query("h1");
  
  m[b1] = 1;
  m[b2] = 2;
  
  
  print(m.length);
  print(b1 == b2);
  print(identical(b1, b2));
  
  //query("button").onClick.listen(go);
}

void go(_) {
  d3.Selection svg = d3.select("svg");
  d3.Selection circle = svg.selectAll("circle");
  
  d3.BoundSelection bound = circle.data([57, 32, 112, 293]);
  d3.EnterSelection enter = bound.enter();
  enter.append("circle");
  var rng = new Math.Random();
  enter.attrFunc("cy", (d,i) => "${rng.nextInt(200)}");
  enter.attrFunc("cx", (d,i) => "${rng.nextInt(200)}");
  enter.attrFunc("r", (d, i) {
    return "${Math.sqrt(d)}";
  });
  

}