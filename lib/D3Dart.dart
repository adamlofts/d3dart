
library D3Dart;

import 'dart:html';
import 'dart:math' as Math;
import 'dart:collection';
import 'dart:async';
import 'dart:svg';
import 'dart:convert';

part 'Scale.dart';
part 'Selection.dart';

part 'layout/Layout.dart';
part 'layout/PieLayout.dart';
part 'layout/HierarchyLayout.dart';
part 'layout/PartitionLayout.dart';

part 'CSV.dart';
part 'SVG.dart';

const num TWO_PI = Math.PI * 2; // τ in d3
const num HALF_PI = Math.PI / 2; // halfπ in d3
const num EPSILON = 1e-6; // ε in d3
const num EPSILON_SQD = EPSILON * EPSILON; // ε2 in d3

typedef String PropertyFunction(dynamic d, int i);
typedef Object KeyFunction(dynamic d, int i);
typedef EachFunction(Element elmt, dynamic d, int i, [int j]);

Selection select(String selector) {
  _Group group = new _Group();
  Element elmt = query(selector);
  if (elmt != null) {
    group.add(elmt);
  }
  return new Selection(null, [group]);
}

Selection selectAll(String selector) {
  _Group group = new _Group();
  group.addAll(queryAll(selector));
  return new Selection(null, [group]);
}

num max(Iterable<Object> data) {
  num v = data.first;
  for (num v1 in data) {
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
List<int> range(int stop, { int start: 0, int step: 1 }) {
  List<int> ret = new List<int>(stop);
  for (int i = 0; i < stop; i += 1) {
    ret[i] = i;
  }
  return ret;
}
