
import 'dart:html';

import 'package:unittest/unittest.dart';

import '../lib/D3Dart.dart';

void main() {
  Element $test = query("#test");
  
  test('Selection', () {
    Selection test = select("#test");
    test.text = (a,b) => "Hello";
    expect($test.text, equals("Hello"));
    $test.text = "";
    
    Element p1 = new ParagraphElement();
    Element p2 = new ParagraphElement();
    $test.append(p1);
    $test.append(p2);
    
    Selection sub = test.selectAll("p");
    sub.text = (a,b) => "Bye";
    expect($test.children.first.text, equals("Bye"));
  });
  
  test('BarChart', () {
    var data = [4, 8, 15, 16, 23, 42];
    $test.text = "";
    BoundSelection selection = select("#test").selectAll("div").data(data);
    EnterSelection sel = selection.enter();
    sel.append("div");
    
    Scale.linear(domain: [0, max(data)], range: [0, 420]);
    sel.style.width = (d, i) => "${d * 10}px";
    sel.style.height = (d, i) => "20px";
    sel.text = (d, i) => "${d}";
    sel.style.backgroundColor = (d, i) => "blue";
    
    expect($test.children.first.style.width, equals("40px"));
    expect($test.children.last.text, equals("42"));
  });
}
