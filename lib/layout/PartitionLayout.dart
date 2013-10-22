
part of D3Dart;

class PartitionLayout {

  HierarchyLayout _layout = new HierarchyLayout();
  List<num> size = [1, 1];
  
  PartitionLayout();
  
  List<Map> call(Map root) {
    var nodes = _layout(root);
    _position(nodes[0], 0, size[0], size[1] / _depth(nodes[0]));
    return nodes;
  }
  
  List<Map> nodes(Object d, int i) => this(d);
  
  void _position(Map node, num x, num dx, num dy) {
    List children = node["children"];
    node["x"] = x;
    node["y"] = node["depth"] * dy;
    node["dx"] = dx;
    node["dy"] = dy;
    
    if ((children != null) && (children.length > 0)) {
      int i = -1;
      Map c;
      num d;
      
      if (node["value"] != null) {
        dx = dx / node["value"];
      } else {
        dx = 0;
      }
      while (++i < children.length) {
        c = children[i];
        d = c["value"] * dx;
        _position(c, x, d, dy);
        x += d;
      }
    }
  }

  int _depth(Map node) {
    List children = node["children"];
    int d = 0;
    if ((children != null) && (children.length > 0)) {
      var i = -1;
      while (++i < children.length) d = Math.max(d, _depth(children[i]));
    }
    return 1 + d;
  }
  
  void set value(HierarchyValueFunction v) {
    _layout.value = v;
  }
  
  void set children(ChildrenFunction v) {
    _layout.children = v;
  }
}

/**
import "layout";
import "hierarchy";

d3.layout.partition = function() {
  var hierarchy = d3.layout.hierarchy(),
      size = [1, 1]; // width, height

  function position(node, x, dx, dy) {
    var children = node.children;
    node.x = x;
    node.y = node.depth * dy;
    node.dx = dx;
    node.dy = dy;
    if (children && (n = children.length)) {
      var i = -1,
          n,
          c,
          d;
      dx = node.value ? dx / node.value : 0;
      while (++i < n) {
        position(c = children[i], x, d = c.value * dx, dy);
        x += d;
      }
    }
  }

  function depth(node) {
    var children = node.children,
        d = 0;
    if (children && (n = children.length)) {
      var i = -1,
          n;
      while (++i < n) d = Math.max(d, depth(children[i]));
    }
    return 1 + d;
  }

  function partition(d, i) {
    var nodes = hierarchy.call(this, d, i);
    position(nodes[0], 0, size[0], size[1] / depth(nodes[0]));
    return nodes;
  }

  return d3_layout_hierarchyRebind(partition, hierarchy);
};
*/