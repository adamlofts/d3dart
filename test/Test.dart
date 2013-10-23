
import 'dart:html' as html;

import 'package:unittest/unittest.dart';

import '../lib/D3Dart.dart';

void main() {
  html.Element $test = html.querySelector("#test");
  
  test('Datum', () {
    Selection sel = select("#test");
    sel.datum = 1;
    expect(sel.datum, equals(1));
    
    Selection sel2 = select("#test");
    expect(sel.datum, equals(1));
    
    Selection empty = select("#doesnotexist");
    empty.datum = 25;
    expect(empty.datum, equals(null));
  });
  
  test("Data", () {
    $test.text = "";
    Selection sel = select("#test").selectAll("p");
    BoundSelection bsel = sel.data([1, 2, 3]);
    expect(bsel.size, equals(0));
    expect(bsel.enter.size, equals(3));
    expect(bsel.exit.size, equals(0));

    $test.append(new html.ParagraphElement());
    sel = select("#test").selectAll("p");
    bsel = sel.data([1, 2, 3]);
    expect(bsel.size, equals(1));
    expect(bsel.enter.size, equals(2));
    expect(bsel.exit.size, equals(0));
    
    $test.append(new html.ParagraphElement());
    sel = select("#test").selectAll("p");
    bsel = sel.data([1]);
    expect(bsel.size, equals(1));
    expect(bsel.enter.size, equals(0));
    expect(bsel.exit.size, equals(1));
  });

  test('Selection', () {
    
    Selection sel = select("body");
    Selection sel2 = sel.select("#doesnotexist");
    expect(sel2.length, 1); // Empty group
    
    Selection test = select("#test");
    test.text = "Hello";
    expect($test.text, equals("Hello"));
    $test.text = "";
    
    html.Element p1 = new html.ParagraphElement();
    html.Element p2 = new html.ParagraphElement();
    $test.append(p1);
    $test.append(p2);
    
    sel = test.selectAll("p");
    sel.textFunc = (a,b) => "Bye";
    expect($test.children.first.text, equals("Bye"));
  });
  
  test('BarChart', () {
    var data = [4, 8, 15, 16, 23, 42];
    $test.text = "";
    BoundSelection selection = select("#test").selectAll("div").data(data);
    Selection sel = selection.enter;
    sel.append("div");
    
    Scale.linear(domain: [0, max(data)], range: [0, 420]);
    sel.style.width = (d, i) => "${d * 10}px";
    sel.style.height = (d, i) => "20px";
    sel.textFunc = (d, i) => "${d}";
    sel.style.backgroundColor = (d, i) => "blue";
    
    expect($test.children.first.style.width, equals("40px"));
    expect($test.children.last.text, equals("42"));
  });
}
