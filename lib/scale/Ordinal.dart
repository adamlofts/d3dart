
part of D3Dart;

class Ordinal extends Scale {
  
  List _domain = [];
  
  List _range;
  int rangeBand;
  Map _ranger;
  
  Map<Object, int> _index = {};
  
  Ordinal({ List range }) {
    _range = range;
  }
  
  List get range => _range;
  
  void set range(List value) {
    _range = value;
    rangeBand = 0;
    _ranger = {"t": "range", "a": [value]};
  }
  
  List get domain {
    return _domain;
  }
  
  void set domain(List x) {
    _domain = [];
    _index = {};
    var i = -1, n = x.length, xi;
    while (++i < n) {
      if (!_index.containsKey(xi = x[i])) {
        _domain.add(xi);
        _index[xi] = _domain.length;
      }
    }
    if (_ranger["t"] == "range") {
      range = _ranger["a"][0];
    } else if (_ranger["t"] == "rangePoints") {
      rangePoints(_ranger["a"][0], padding: _ranger["a"][1]);
    } else {      
      rangeRoundBands(_ranger["a"][0], padding: _ranger["a"][1], outerPadding: _ranger["a"][2]);
    }
  }
  
  Object call(Object x) {
    int index = _index[x];
    if (index == null) {
      _domain.add(x);
      index = _domain.length;
      _index[x] = index;
    }
    return _range[(index - 1) % _range.length];
  }
  
  void rangePoints(List x, {num padding: 0}) {
    var start = x[0],
        stop = x[1],
        step = (stop - start) / (Math.max(1, domain.length - 1) + padding);
    range = _steps(domain.length < 2 ? (start + stop) / 2 : start + step * padding / 2, step);
    rangeBand = 0;
    _ranger = {"t": "rangePoints", "a": [x, padding]};
  }
  
  void rangeRoundBands(List x, { num padding: 0, num outerPadding }) {
    if (outerPadding == null) {
      outerPadding = padding;
    }
    var reverse = x[1] < x[0],
        start,
        stop;
    if (reverse) {
        start = x[1];
        stop = x[0];
    } else {
        start = x[0];
        stop = x[1];
    }
    var step = ((stop - start) / (_domain.length - padding + 2 * outerPadding)).floor(),
        error = stop - start - (_domain.length - padding) * step;
    _range = _steps(start + (error / 2).round(), step);
    if (reverse) {
      _range = _range.reversed.toList();
    }
    rangeBand = (step * (1 - padding)).round();
    _ranger = {"t": "rangeRoundBands", "a": [x, padding, outerPadding]};
  }
  
  List _steps(start, step) {
    return d3range(_domain.length).map((i) => start + step * i).toList();
  }
  
  List rangeExtent() {
    return d3_scaleExtent(_range);
  }
}


/**

import "../arrays/map";
import "../arrays/range";
import "scale";

d3.scale.ordinal = function() {
  return d3_scale_ordinal([], {t: "range", a: [[]]});
};

function d3_scale_ordinal(domain, ranger) {
  var index,
      range,
      rangeBand;

  function scale(x) {
    return range[((index.get(x) || ranger.t === "range" && index.set(x, domain.push(x))) - 1) % range.length];
  }

  function steps(start, step) {
    return d3.range(domain.length).map(function(i) { return start + step * i; });
  }

  scale.domain = function(x) {
    if (!arguments.length) return domain;
    domain = [];
    index = new d3_Map;
    var i = -1, n = x.length, xi;
    while (++i < n) if (!index.has(xi = x[i])) index.set(xi, domain.push(xi));
    return scale[ranger.t].apply(scale, ranger.a);
  };

  scale.range = function(x) {
    if (!arguments.length) return range;
    range = x;
    rangeBand = 0;
    ranger = {t: "range", a: arguments};
    return scale;
  };

  scale.rangePoints = function(x, padding) {
    if (arguments.length < 2) padding = 0;
    var start = x[0],
        stop = x[1],
        step = (stop - start) / (Math.max(1, domain.length - 1) + padding);
    range = steps(domain.length < 2 ? (start + stop) / 2 : start + step * padding / 2, step);
    rangeBand = 0;
    ranger = {t: "rangePoints", a: arguments};
    return scale;
  };

  scale.rangeBands = function(x, padding, outerPadding) {
    if (arguments.length < 2) padding = 0;
    if (arguments.length < 3) outerPadding = padding;
    var reverse = x[1] < x[0],
        start = x[reverse - 0],
        stop = x[1 - reverse],
        step = (stop - start) / (domain.length - padding + 2 * outerPadding);
    range = steps(start + step * outerPadding, step);
    if (reverse) range.reverse();
    rangeBand = step * (1 - padding);
    ranger = {t: "rangeBands", a: arguments};
    return scale;
  };

  scale.rangeRoundBands = function(x, padding, outerPadding) {
    if (arguments.length < 2) padding = 0;
    if (arguments.length < 3) outerPadding = padding;
    var reverse = x[1] < x[0],
        start = x[reverse - 0],
        stop = x[1 - reverse],
        step = Math.floor((stop - start) / (domain.length - padding + 2 * outerPadding)),
        error = stop - start - (domain.length - padding) * step;
    range = steps(start + Math.round(error / 2), step);
    if (reverse) range.reverse();
    rangeBand = Math.round(step * (1 - padding));
    ranger = {t: "rangeRoundBands", a: arguments};
    return scale;
  };

  scale.rangeBand = function() {
    return rangeBand;
  };

  scale.rangeExtent = function() {
    return d3_scaleExtent(ranger.a[0]);
  };

  scale.copy = function() {
    return d3_scale_ordinal(domain, ranger);
  };

  return scale.domain(domain);
}
*/
