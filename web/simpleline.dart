import 'package:d3dart/D3Dart.dart' as d3;
import 'dart:html';

var DATASET = [[{
  'x': 'White',
  'y': 'Cats',
  'value': 21
}, {
  'x': 'Black',
  'y': 'Cats',
  'value': 12
}, {
  'x': 'Ginger',
  'y': 'Cats',
  'value': 8
}], [{
  'x': 'White',
  'y': 'Dogs',
  'value': 11
}, {
  'x': 'Black',
  'y': 'Dogs',
  'value': 18
}, {
  'x': 'Ginger',
  'y': 'Dogs',
  'value': 15
}]];

void main() {
  d3.LineChart chart = new d3.LineChart(querySelector("#chart"));
  chart.yAxisLabel = "Number of animals";
  chart.margin = {"top": 0, "right": 200, "bottom": 250, "left": 50};
  chart.has_legend = true;
  chart.data = DATASET;
}
