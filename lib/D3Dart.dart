
library D3Dart;

import 'dart:html';
import 'dart:math' as Math;
import 'dart:collection';
import 'dart:async';
import 'dart:svg';
import 'dart:convert';

part 'Selection.dart';

part 'arrays/Extent.dart';

part 'interpolate/Interpolate.dart';

part 'scale/Bilinear.dart';
part 'scale/Ordinal.dart';
part 'scale/Scale.dart';
part 'scale/LinearScale.dart';

part 'layout/Layout.dart';
part 'layout/PieLayout.dart';
part 'layout/HierarchyLayout.dart';
part 'layout/PartitionLayout.dart';
part 'layout/TreemapLayout.dart';

part 'svg/Arc.dart';
part 'svg/Axis.dart';
part 'svg/Line.dart';

part 'CSV.dart';

part 'chart/LineChart.dart';
part 'chart/PieChart.dart';
part 'chart/ColumnChart.dart';

const num TWO_PI = Math.PI * 2; // τ in d3
const num HALF_PI = Math.PI / 2; // halfπ in d3
const num EPSILON = 1e-6; // ε in d3
const num EPSILON_SQD = EPSILON * EPSILON; // ε2 in d3

typedef Object PropertyFunction(dynamic d, int i);
typedef Object KeyFunction(dynamic d, int i);
typedef EachFunction(Element elmt, dynamic d, int i, [int j]);

Selection selectElement(Element elmt) {
  _Group group = new _Group();
  if (elmt != null) {
    group.add(elmt);
  }
  return new Selection(null, [group]);
}

Selection select(String selector) {
  return selectElement(querySelector(selector));
}

Selection selectAll(String selector) {
  _Group group = new _Group();
  group.addAll(querySelectorAll(selector));
  return new Selection(null, [group]);
}

num max(Iterable<Object> data, { num f (Object): null }) {
  var v = data.first;
  if (f != null) {
    v = f(v);
  }
  for (var v1 in data) {
    if (f != null) {
      v1 = f(v1);
    }
    if (v1 > v) {
      v = v1;
    }
  }
  return v;
}

num sum(Iterable<Object> data) {
  num v = 0;
  for (num v1 in data) {
    v += v1;
  }
  return v;
}

/**
 * Generates an array containing an arithmetic progression, similar to the Python built-in range.
 * 
 * This method is often used to iterate over a sequence of numeric or integer values, such as the indexes into an array.
 * Unlike the Python version, the arguments are not required to be integers, though the results are more predictable
 * if they are due to floating point precision. If step is omitted, it defaults to 1. If start is omitted, it defaults to 0.
 * The stop value is not included in the result. The full form returns an array of numbers [start, start + step, start + 2 * step, …].
 * If step is positive, the last element is the largest start + i * step less than stop; if step is negative, the last element is the
 * smallest start + i * step greater than stop. If the returned array would contain an infinite number of values,
 * an error is thrown rather than causing an infinite loop.
 */
List<num> d3range(num stop, { num start: 0, num step: 1 }) {
  List<num> ret = new List<num>();
  for (num v = start; v < stop; v += step) {
    ret.add(v);
  }
  return ret;
}

/**
 * Color to hex string. Convert num like 0xFF00FF to #FF00FF
 */
String colorToHex(int color) {
  String hex = color.toRadixString(16);
  return "#${hex.padLeft(6, '0')}";
}
