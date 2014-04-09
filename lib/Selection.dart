
part of D3Dart;

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
  
  factory Selection.copy(Selection s) {
    return s.selectFunc((Element elmt, dynamic d, int i, [int j]) => elmt);
  }
  
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
      elmt.attributes[name] = f(d, i).toString();
    });
  }
  
  Selection select(String selector) {
    return selectFunc((Element elmt, dynamic d, int i, [int j]) => elmt.querySelector(selector));
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
          subgroup.addAll(elmt.querySelectorAll(selector)); // subgroups.push(subgroup = d3_array(selector.call(node, node.__data__, i, j)));
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
  
  List _dataBind(_Group group, List<Object> group_data, KeyFunction key) {
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
    
    return [enter_group, update_group, exit_group];
  }
  
  BoundSelection dataFunc(KeyFunction f, { KeyFunction key: null }) {
    List<_Group> enter = [];
    List<_Group> update = [];
    List<_Group> exit = [];
    
    int i = 0;
    for (_Group group in _groups) {
      List l = _dataBind(group, f(_datum[group.parentNode], i), key);      
      enter.add(l[0]);
      update.add(l[1]);
      exit.add(l[2]);
      i += 1;
    }
    return new BoundSelection(this, update, enter, exit);
  }

  BoundSelection data(List<Object> group_data, { KeyFunction key: null }) {
    List<_Group> enter = [];
    List<_Group> update = [];
    List<_Group> exit = [];
    
    for (_Group group in _groups) {
      List l = _dataBind(group, group_data, key);
      enter.add(l[0]);
      update.add(l[1]);
      exit.add(l[2]);
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
  
  static final Set HTML_TAGS = new Set.from(const ["div"]);
  
  Selection append(String tag) {
    bool is_html = HTML_TAGS.contains(tag);
    return selectFunc((Element elmt, dynamic d, int i, [int j]) {
      Element child;
      if (is_html) {
        child = new Element.tag(tag);
      } else {
        child = new SvgElement.tag(tag);
      }
      elmt.append(child);
      return child;
    });
  }
  
  void call(Function f) {
    f(this);
  }
  
  /*
  Selection get transition {
      var id = d3_transitionInheritId || ++d3_transitionId,
          subgroups = [],
          subgroup,
          node,
          transition = d3_transitionInherit || {time: Date.now(), ease: d3_ease_cubicInOut, delay: 0, duration: 250};

          for (var j = -1, m = this.length; ++j < m;) {
            subgroups.push(subgroup = []);
            for (var group = this[j], i = -1, n = group.length; ++i < n;) {
              if (node = group[i]) d3_transitionNode(node, i, id, transition);
              subgroup.push(node);
            }
          }

          return d3_transition(subgroups, id);
  }
   */
  
  // Events
  
  static const _SelectionEventStreamProvider<MouseEvent> clickEvent = const _SelectionEventStreamProvider<MouseEvent>(Element.clickEvent);
  Stream<MouseEvent> get onClick => clickEvent.forSelection(this);

  static const _SelectionEventStreamProvider<MouseEvent> mouseOverEvent = const _SelectionEventStreamProvider<MouseEvent>(Element.mouseOverEvent);
  Stream<MouseEvent> get onMouseOver => mouseOverEvent.forSelection(this);

  static const _SelectionEventStreamProvider<MouseEvent> mouseOutEvent = const _SelectionEventStreamProvider<MouseEvent>(Element.mouseOutEvent);
  Stream<MouseEvent> get onMouseOut => mouseOutEvent.forSelection(this);
}

typedef ElementStream ElementStreamFunction(Element elmt);

class _SelectionEventStreamProvider<T extends Event> {
  
  final EventStreamProvider provider;
  const _SelectionEventStreamProvider(EventStreamProvider this.provider);

  Stream<T> forSelection(Selection s, {bool useCapture: false}) {
    StreamController<T> controller = new StreamController<T>.broadcast();
    
    s.each((Element elmt, dynamic d, int i, [int j]) {
      provider.forElement(elmt, useCapture: useCapture).listen((Event evt) {
        controller.add(evt);
      });
    });
    
    return controller.stream;
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
  void set fillRule(PropertyFunction f) => setProperty("fill-rule", f);
  void set stroke(PropertyFunction f) => setProperty("stroke", f);
  void set position(PropertyFunction f) => setProperty("position", f);
  void set left(PropertyFunction f) => setProperty("left", f);
  void set top(PropertyFunction f) => setProperty("top", f);
  
  void set textAnchorConst(String v) {
    textAnchor = (d, i) => v;
  }
  
  void set fillConst(String v) {
    fill = (d, i) => v;
  }
  
  void set positionConst(String v) {
    position = (d, i) => v;
  }
  
  void set widthConst(String v) {
    width = (d, i) => v;
  }
  
  void set heightConst(String v) {
    height = (d, i) => v;
  }
  
  void set leftConst(String v) {
    left = (d, i) => v;
  }
  
  void set topConst(String v) {
    top = (d, i) => v;
  }
}
