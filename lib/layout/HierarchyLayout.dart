
part of D3Dart;

typedef List ChildrenFunction(Object d, int depth);

class HierarchyLayout {

  // FIXME Function sort;
  
  ChildrenFunction children = (Object d, int depth) => (d as Map)["children"] as List;
  HierarchyValueFunction value = (Object d, int depth) => (d as Map)["value"];
  
  HierarchyLayout();
  
  List<Map> call(Map root) {
    var nodes = [];
    _recurse(root, 0, nodes);
    return nodes;
  }
  
  num revalue(Map node, {int depth: 0}) {
    var children = node["children"],
        v = 0;
        
    if ((children != null) && (children.length > 0)) {
      var i = -1,
          n = children.length,
          j = depth + 1;
      while (++i < n) v += revalue(children[i], depth: j);
    } else if (value != null) {
      v = value(node, depth); // || 0;
    }
    if (value != null) node["value"] = v;
    return v;
    
    // throw new UnimplementedError(); 
    //_revalue(root, 0);
  }
  
  void _recurse(Map node, int depth, List nodes) {
    List<Map> childs = children(node, depth);
    node["depth"] = depth;
    nodes.add(node);
    if ((childs != null) && childs.isNotEmpty) {
      int n = childs.length;
      int i = -1;
      List c = new List(n);
      int v = 0;
      int j = depth + 1;
      Map d;
      
      while (++i < n) {
        d = childs[i];
        _recurse(d, j, nodes);
        c[i] = d;
        d["parent"] = node;
        v += d["value"];
      }
      //       if (sort) c.sort(sort);
      if (value != null) {
        node["value"] = v;
      }
    } else {
      node.remove("children");
      if (value != null) {
        num vv = value(node, depth);
        if (vv == null) {
          vv = 0;
        }
        node["value"] = vv;
      }
      /**
       * delete node.children;
      if (value) {
        node.value = +value.call(hierarchy, node, depth) || 0;
      }
       */
    }
  }
  /*
   * function recurse(node, depth, nodes) {
    var childs = children.call(hierarchy, node, depth);
    node.depth = depth;
    nodes.push(node);
    if (childs && (n = childs.length)) {
      var i = -1,
          n,
          c = node.children = new Array(n),
          v = 0,
          j = depth + 1,
          d;
      while (++i < n) {
        d = c[i] = recurse(childs[i], j, nodes);
        d.parent = node;
        v += d.value;
      }
      if (sort) c.sort(sort);
      if (value) node.value = v;
    } else {
      delete node.children;
      if (value) {
        node.value = +value.call(hierarchy, node, depth) || 0;
      }
    }
    return node;
  }

  // Recursively re-evaluates the node value.
  function revalue(node, depth) {
    var children = node.children,
        v = 0;
    if (children && (n = children.length)) {
      var i = -1,
          n,
          j = depth + 1;
      while (++i < n) v += revalue(children[i], j);
    } else if (value) {
      v = +value.call(hierarchy, node, depth) || 0;
    }
    if (value) node.value = v;
    return v;
  }
   * 
   */
}

/*

import "../arrays/range";
import "../arrays/sum";
import "../math/trigonometry";
import "layout";

d3.layout.pie = function() {
  var value = Number,
      sort = d3_layout_pieSortByValue,
      startAngle = 0,
      endAngle = τ;

  function pie(data) {

    // Compute the numeric values for each data element.
    var values = data.map(function(d, i) { return +value.call(pie, d, i); });

    // Compute the start angle.
    var a = +(typeof startAngle === "function"
        ? startAngle.apply(this, arguments)
        : startAngle);

    // Compute the angular scale factor: from value to radians.
    var k = ((typeof endAngle === "function"
        ? endAngle.apply(this, arguments)
        : endAngle) - a)
        / d3.sum(values);

    // Optionally sort the data.
    

    
  }

  /**
   * Specifies the value function *x*, which returns a nonnegative numeric value
   * for each datum. The default value function is `Number`. The value function
   * is passed two arguments: the current datum and the current index.
   */
  pie.value = function(x) {
    if (!arguments.length) return value;
    value = x;
    return pie;
  };

  /**
   * Specifies a sort comparison operator *x*. The comparator is passed two data
   * elements from the data array, a and b; it returns a negative value if a is
   * less than b, a positive value if a is greater than b, and zero if a equals
   * b.
   */
  pie.sort = function(x) {
    if (!arguments.length) return sort;
    sort = x;
    return pie;
  };

  /**
   * Specifies the overall start angle of the pie chart. Defaults to 0. The
   * start angle can be specified either as a constant or as a function; in the
   * case of a function, it is evaluated once per array (as opposed to per
   * element).
   */
  pie.startAngle = function(x) {
    if (!arguments.length) return startAngle;
    startAngle = x;
    return pie;
  };

  /**
   * Specifies the overall end angle of the pie chart. Defaults to 2π. The
   * end angle can be specified either as a constant or as a function; in the
   * case of a function, it is evaluated once per array (as opposed to per
   * element).
   */
  pie.endAngle = function(x) {
    if (!arguments.length) return endAngle;
    endAngle = x;
    return pie;
  };

  return pie;
};

var d3_layout_pieSortByValue = {};

*/

