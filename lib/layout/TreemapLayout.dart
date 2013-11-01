
part of D3Dart;

class TreemapLayout {

  Expando _area = new Expando();
  
  HierarchyLayout _hierarchy = new HierarchyLayout();
  List<num> size = [1, 1];
  var padding;
  var pad = d3_layout_treemapPadNull;
  bool sticky = false;
  var stickies;
  var mode = "squarify";
  num ratio = 0.5 * (1 + Math.sqrt(5)); // golden ratio
  
  TreemapLayout();
  
  // Compute the area for each child based on value & scale.
  void scale(children, k) {
    var i = -1,
        n = children.length,
        child;
    num area;
    while (++i < n) {
      area = (child = children[i])["value"] * (k < 0 ? 0 : k);
      if (area.isNaN || area <= 0) {
        area = 0;
      }
      _area[child] = area;
    }
  }

  // Recursively arranges the specified node's children into squarified rows.
  void squarify(node) {
    List children = node["children"];
    if ((children != null) && (children.length > 0)) {
      var rect = pad(node),
          row = [],
          remaining = children.sublist(0), // copy-on-write
          child,
          best = double.INFINITY, // the best row score so far
          score, // the current row score
          u = mode == "slice" ? rect["dx"]
            : mode == "dice" ? rect["dy"]
            : mode == "slice-dice" ? node["depth"] & 1 ? rect["dy"] : rect["dx"]
            : Math.min(rect["dx"], rect["dy"]), // initial orientation
          n;
      scale(remaining, rect["dx"] * rect["dy"] / node["value"]);
      _area[row] = 0;
      while ((n = remaining.length) > 0) {
        row.add(child = remaining[n - 1]);
        _area[row] += _area[child];
        if (mode != "squarify" || (score = worst(row, u)) <= best) { // continue with this orientation
          remaining.removeLast();
          best = score;
        } else { // abort, and try a different orientation
          _area[row] -= _area[row.removeLast()];
          position(row, u, rect, false);
          u = Math.min(rect["dx"], rect["dy"]);
          row.clear();
          _area[row] = 0;
          best = double.INFINITY;
        }
        print("DART SCORE ${score}");
      }
      if (row.length > 0) {
        position(row, u, rect, true);
        row.clear();
        _area[row] = 0;
      }
      children.forEach(squarify);
    }
  }
  
  void stickify(node) {
    List children = node["children"];
    if ((children != null) && (children.length > 0)) {
      var rect = pad(node),
          remaining = children.sublist(0), // copy-on-write
          child,
          row = [];
      scale(remaining, rect["dx"] * rect["dy"] / node["value"]);
      _area[row] = 0;
      while (remaining.length > 0) {
        child = remaining.removeLast();
        row.add(child);
        _area[row] += _area[child];
        if (child["z"] != null) {
          position(row, (child["z"] != 0) ? rect["dx"] : rect["dy"], rect, remaining.length == 0);
          row.clear();
          _area[row] = 0;
        }
      }
      children.forEach(stickify);
    }
  }
  
  num worst(row, u) {
    var s = _area[row],
        r,
        rmax = 0,
        rmin = double.INFINITY,
        i = -1,
        n = row.length;
    while (++i < n) {
      r = _area[row[i]];
      if (r == 0) {
        continue;
      }
      if (r < rmin) rmin = r;
      if (r > rmax) rmax = r;
    }
    s *= s;
    u *= u;
    return (s != 0)
        ? Math.max((u * rmax * ratio) / s, s / (u * rmin * ratio))
        : double.INFINITY;
  }

  // Positions the specified row of nodes. Modifies `rect`.
  void position(row, u, rect, flush) {
    var i = -1,
        n = row.length,
        x = rect["x"],
        y = rect["y"],
        v = (u != 0) ? round(_area[row] / u) : 0,
        o;
    if (u == rect["dx"]) { // horizontal subdivision
      if (flush || v > rect["dy"]) v = rect["dy"]; // over+underflow
      while (++i < n) {
        o = row[i];
        o["x"] = x;
        o["y"] = y;
        o["dy"] = v;
        x += o["dx"] = Math.min(rect["x"] + rect["dx"] - x, (v != 0) ? round(_area[o] / v) : 0);
      }
      o["z"] = true;
      o["dx"] += rect["x"] + rect["dx"] - x; // rounding error
      rect["y"] += v;
      rect["dy"] -= v;
    } else { // vertical subdivision
      if (flush || v > rect["dx"]) v = rect["dx"]; // over+underflow
      while (++i < n) {
        o = row[i];
        o["x"] = x;
        o["y"] = y;
        o["dx"] = v;
        y += o["dy"] = Math.min(rect["y"] + rect["dy"] - y, (v != 0) ? round(_area[o] / v) : 0);
      }
      o["z"] = false;
      o["dy"] += rect["y"] + rect["dy"] - y; // rounding error
      rect["x"] += v;
      rect["dx"] -= v;
    }
  }
  
  List<Map> call(d) {
    var nodes;
    if (stickies != null) {
      nodes = stickies;
    } else {
      nodes = _hierarchy(d);
    }
    var root = nodes[0];
    root["x"] = 0;
    root["y"] = 0;
    root["dx"] = size[0];
    root["dy"] = size[1];
    if (stickies != null) _hierarchy.revalue(root);
    scale([root], root["dx"] * root["dy"] / root["value"]);
    ((stickies != null) ? stickify : squarify)(root);
    if (sticky) stickies = nodes;
    return nodes;
  }
  
  List<Map> nodes(Object d, int i) => this(d);
  
  void set value(HierarchyValueFunction v) {
    _hierarchy.value = v;
  }
  
  void set children(ChildrenFunction v) {
    _hierarchy.children = v;
  }
  
  static Map d3_layout_treemapPadNull(node) {
    return {"x": node["x"], "y": node["y"], "dx": node["dx"], "dy": node["dy"]};
  }

  num round(num v) {
    return v.round();
  }
}
