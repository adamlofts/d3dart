
library D3Dart;

import 'dart:html';
import 'dart:math' as Math;
import 'dart:collection';

typedef String PropertyFunction(dynamic d, int i);
typedef Object KeyFunction(dynamic d, int i);
typedef EachFunction(Element elmt, dynamic d, int i, [int j]);

class _Group extends ListMixin<Element> {
  Element parentNode;
  List<Element> _list = [];
  
  _Group() {
    
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
  Iterable<Object> _data = [];
  
  Selection(Selection this._parent, List<List<Element>> this._groups);
  
  int get length {
    return _groups.length;
  }
  
  /*
  String get text {
    Element elmt = node;
    if (elmt != null) {
      return elmt.text;
    }
    return '';
  }
  */
  
  void set text(PropertyFunction f) {
    each((Element elmt, dynamic d, int i, [int j]) {
      elmt.text = f(d, i);
    });
  }
  
  _SelectionStyle get style => new _SelectionStyle(this);

  void attr(String name, PropertyFunction f) {
    int index = 0;
    Iterator<Object> data_it = _data.iterator;
    for (Element elmt in _groups) {
      data_it.moveNext();
      Object d = data_it.current;
      dynamic v = f(d, index);
      elmt.attributes[name] = v;
      index += 1;
    }
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
          subelmt = f(node, _datum[node], i, j);
          if (subelmt != null) {
            _datum[subelmt] = _datum[elmt];
          }
        }
        subgroup.add(subelmt);
        i += 1;
      }
      j += 1;
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

  BoundSelection data(Iterable<Object> value, { KeyFunction key: null }) {
    return new BoundSelection(_parent, _groups, value, key);
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
}

class EnterSelection extends Selection {
  EnterSelection(Selection parent, Iterable<Object> _data) : super(parent, []) {
    this._data = _data;
  }

  Selection append(String tag) {
    EachFunction f = (Element elmt, dynamic d, int i, [int j]) {
      Element child = new Element.tag(tag);
      elmt.append(child);
    };
    return this.selectFunc(f);
  }
}

class BoundSelection extends Selection {
  Iterable<Object> _all_data;
  KeyFunction _key;
  Map<Object, Element> _bound;
  int _taken;
  
  BoundSelection(Selection parent, List<_Group> groups, Iterable<Object> this._all_data, KeyFunction this._key) : super(parent, []) {
    _taken = Math.min(groups.length, _data.length);
    this._groups.addAll(groups.take(_taken));
    this._data = _all_data.take(_taken);
  }
  
  EnterSelection enter() {
    int taken = _taken;
    _taken = _all_data.length;
    return new EnterSelection(_parent, _all_data.skip(taken));
  }
  
  Object remove() {
    throw new UnimplementedError();
  }
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
    int index = 0;
    Iterator<Object> data_it = _selection._data.iterator;
    for (Element elmt in _selection._groups) {
      data_it.moveNext();
      Object d = data_it.current;
      dynamic v = f(d, index);
      elmt.style.setProperty(propertyName, v);
      index += 1;
    }
  }

  // CSSStyleRule
  void set color(PropertyFunction f) => setProperty("color", f);
  void set backgroundColor(PropertyFunction f) => setProperty("background-color", f);
  void set fontSize(PropertyFunction f) => setProperty("font-size", f);
  void set width(PropertyFunction f) => setProperty("width", f);
  void set height(PropertyFunction f) => setProperty("height", f);
}

class Scale {
  static PropertyFunction linear({List domain, List range, String suffix: "px"}) {
    return (dynamic d, int i) {
      if (domain != null) {
        d = (d - domain[0]) / domain[1];
      }
      if (range != null) {
        d = d * (range[1] - range[0]);
      }
      return "${d}${suffix}";
    };
  }
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
