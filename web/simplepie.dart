
import 'package:d3dart/D3Dart.dart' as d3;
import 'dart:html';

var DATASET = [{
  'x': 'Cats',
  'value': 21
},{
  'x': 'Dogs',
  'value': 12
},{
  'x': 'Sheep',
  'value': 18
}];

void main() {
  d3.PieChart chart = new d3.PieChart(querySelector("#chart"));
  chart.has_segment_labels = true;
  chart.color = d3.Scale.category20;
  chart.data = DATASET;
}
