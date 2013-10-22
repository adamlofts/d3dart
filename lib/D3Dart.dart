
library D3Dart;

import 'dart:html';
import 'dart:math' as Math;
import 'dart:collection';
import 'dart:async';
import 'dart:svg';
import 'dart:convert';

part 'Scale.dart';

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

class _Group extends ListMixin<Element> {
  Element parentNode;
  List<Element> _list;
  
  _Group([int size]) {
    if (size != null) {
      _list = new List<Element>(size);
    } else {
      _list = [];
    }
  }
  
  Element operator [](int index) {
    return _list[index];
  }

  void operator []=(int index, Element value) {
    _list[index] = value;
  }

  int get length {
    return _list.length;
  }
  
  void set length(int newLength) {
    _list.length = newLength;
  }
}

class Selection {
  
  static Expando _datum = new Expando("__data__");

  Selection _parent;
  List<_Group> _groups;
  
  Selection(Selection this._parent, List<List<Element>> this._groups);
  
  int get length {
    return _groups.length;
  }
  
  void set text(String v) {
    textFunc = (d, i) => v;
  }
  
  void set textFunc(PropertyFunction f) {
    each((Element elmt, dynamic d, int i, [int j]) {
      elmt.text = f(d, i);
    });
  }
  
  _SelectionStyle get style => new _SelectionStyle(this);

  void attr(String name, Object v) {
    attrFunc(name, (d, i) => v.toString());
  }
  
  void attrFunc(String name, PropertyFunction f) {
    each((Element elmt, dynamic d, int i, [int j]) {
      elmt.attributes[name] = f(d, i);
    });
  }
  
  Selection select(String selector) {
    return selectFunc((Element elmt, dynamic d, int i, [int j]) => elmt.query(selector));
  }
  
  Selection selectFunc(EachFunction f) {
    int j = 0;
    List<_Group> subgroups = _groups.map((_Group group) {
      _Group subgroup = new _Group();
      subgroup.parentNode = group.parentNode;
      int i = 0;
      for (Element elmt in group) {
        Element subelmt;
        if (elmt != null) {
          subelmt = f(elmt, _datum[elmt], i, j);
          if (subelmt != null) {
            _datum[subelmt] = _datum[elmt];
          }
        }
        subgroup.add(subelmt);
        i += 1;
      }
      j += 1;
      return subgroup;
    }).toList();
    return new Selection(null, subgroups);
  }
  
  Selection selectAll(String selector) {
    List<_Group> subgroups = [];
    int j = 0;
    for (_Group group in _groups) {
      int i = 0;
      for (Element elmt in group) {
        if (elmt != null) {
          _Group subgroup = new _Group();
          subgroup.parentNode = elmt;
          subgroup.addAll(elmt.queryAll(selector)); // subgroups.push(subgroup = d3_array(selector.call(node, node.__data__, i, j)));
          subgroups.add(subgroup);
        }
        i += 1;
      }
      j += 1;
    }
    return new Selection(null, subgroups);
  }

  Element _createDataNode(Object data) { // See: https://github.com/mbostock/d3/blob/master/src/selection/data.js#L116
    Element elmt = new SpanElement();
    _datum[elmt] = data;
    return elmt;
  }
  
  BoundSelection dataFunc(KeyFunction f, { KeyFunction key: null }) {
    int i = -1;
    List<Object> group_data = _groups.map((_Group group) {
      i += 1;
      return f(_datum[group.parentNode], i);
    }).toList();
    return data(group_data[0], key: key);
  }

  BoundSelection data(List<Object> group_data, { KeyFunction key: null }) {
    List<_Group> enter = [];
    List<_Group> update = [];
    List<_Group> exit = [];
    
    for (_Group group in _groups) {
      int n = group.length;
      int m = group_data.length;
      int n0 = Math.min(n, m);
      int i;
      
      _Group enter_group = new _Group(m);
      _Group update_group = new _Group(m);
      _Group exit_group = new _Group(n);
      
      enter_group.parentNode = group.parentNode;
      update_group.parentNode = group.parentNode;
      exit_group.parentNode = group.parentNode;
      
      if (key != null) {
        throw new UnimplementedError();
      } else {
        for (i = 0; i < n0; i += 1) {
          Element node = group[i];
          Object node_data = group_data[i];
          if (node != null) {
            _datum[node] = node_data;
            update_group[i] = node;
          } else {
            enter_group[i] = _createDataNode(node_data);
          }
        }
        for (; i < m; ++i) {
          enter_group[i] = _createDataNode(group_data[i]);
        }
        for (; i < n; ++i) {
          exit_group[i] = group[i];
        }
      }
      
      enter.add(enter_group);
      update.add(update_group);
      exit.add(exit_group);
    }
    return new BoundSelection(this, update, enter, exit);
  }
  
  /**
   * Gets or sets the bound data for each selected element.
   * 
   * Unlike the selection.data method, this method does not compute a join (and thus does not compute enter and exit selections). 
   */
  Object get datum {
    Element elmt = node;
    if (elmt != null) {
      return _datum[elmt];
    }
    return null;
  }
  
  void set datum(Object value) {
    this.each((Element elmt, dynamic d, int i, [int j]) {
      _datum[elmt] = value;
    });
  }
  
  /**
   * Returns the first non-null element in the current selection. If the selection is empty, returns null.
   */
  Element get node {
    for (_Group group in _groups) {
      for (Element elmt in group) {
        if (elmt != null) {
          return elmt;
        }
      }
    }
    return null;
  }
  
  /**
   * Invokes the specified function for each element in the current selection, passing in the current datum d and index i,
   * with the this context of the current DOM element. This operator is used internally by nearly every other operator,
   * and can be used to invoke arbitrary code for each selected element.
   * 
   * The each operator can be used to process selections recursively, by using d3.select(this) within the callback function.
   */
  void each(EachFunction f) {
    int j = 0;
    for (_Group group in _groups) {
      int i = 0;
      for (Element elmt in group) {
        if (elmt != null) {
          f(elmt, _datum[elmt], i, j);
        }
        i += 1;
      }
      j += 1;
    }
  }
  
  /**
   * Returns the total number of elements in the current selection.
   */
  int get size {
    int n = 0;
    each((Element elmt, dynamic d, int i, [int j]) => n += 1);
    return n;
  }
  
  /**
   * Returns true if the current selection is empty; a selection is empty if it contains no non-null elements.
   */
  bool get empty {
    return this.node == null;
  }
  
  Selection append(String tag) {
    return selectFunc((Element elmt, dynamic d, int i, [int j]) {
      Element child = new SvgElement.tag(tag);
      elmt.append(child);
      return child;
    });
  }
}

class BoundSelection extends Selection {
  List<_Group> _enter;
  List<_Group> _exit;
  
  BoundSelection(Selection parent, List<_Group> groups, List<_Group> this._enter, List<_Group> this._exit) : super(parent, groups) {
  }
  
  Selection get enter {
    return new EnterSelection(this, _enter);
  }
  
  Selection get exit {
    return new Selection(this, _exit);
  }
}

class EnterSelection extends Selection {
  EnterSelection(Selection parent, List<_Group> groups) : super(parent, groups) {
  }
  
  Selection selectFunc(EachFunction f) {
    int j = 0;
    List<_Group> subgroups = _groups.map((_Group group) {
      _Group subgroup = new _Group();
      //     upgroup = (group = this[j]).update;
      subgroup.parentNode = group.parentNode;
      int i = 0;
      for (Element elmt in group) {
        Element subelmt;
        if (elmt != null) {
          subelmt = f(group.parentNode, Selection._datum[elmt], i, j);
          group[i] = subelmt; // FIXME: Don't think this is quite right see: https://github.com/mbostock/d3/blob/master/src/selection/enter-select.js#L13
          if (subelmt != null) {
            Selection._datum[subelmt] = Selection._datum[elmt];
          }
        }
        subgroup.add(subelmt);
        i += 1;
      }
      j += 1;
      return subgroup;
    }).toList();
    return new Selection(null, subgroups);
  }
  
/*
 * d3_selection_enterPrototype.select = function(selector) {
  var subgroups = [],
      subgroup,
      subnode,
      upgroup,
      group,
      node;

  for (var j = -1, m = this.length; ++j < m;) {
    upgroup = (group = this[j]).update;
    subgroups.push(subgroup = []);
    subgroup.parentNode = group.parentNode;
    for (var i = -1, n = group.length; ++i < n;) {
      if (node = group[i]) {
        subgroup.push(upgroup[i] = subnode = selector.call(group.parentNode, node.__data__, i, j));
        subnode.__data__ = node.__data__;
      } else {
        subgroup.push(null);
      }
    }
  }

  return d3_selection(subgroups);
};
 */
}

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

class _SelectionStyle {
  Selection _selection;
  _SelectionStyle(Selection this._selection);
  
  void setProperty(String propertyName, PropertyFunction f) {
    _selection.each((Element elmt, dynamic d, int i, [int j]) {
      dynamic v = f(d, i);
      elmt.style.setProperty(propertyName, v);
    });
  }

  // CSSStyleRule
  void set color(PropertyFunction f) => setProperty("color", f);
  void set backgroundColor(PropertyFunction f) => setProperty("background-color", f);
  void set fontSize(PropertyFunction f) => setProperty("font-size", f);
  void set width(PropertyFunction f) => setProperty("width", f);
  void set height(PropertyFunction f) => setProperty("height", f);
  void set textAnchor(PropertyFunction f) => setProperty("text-anchor", f);
  void set fill(PropertyFunction f) => setProperty("fill", f);
  void set stroke(PropertyFunction f) => setProperty("stroke", f);
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
