
part of D3Dart;

List d3_scaleExtent(domain) {
  var start = domain[0], stop = domain[domain.length - 1];
  if (start < stop) { return [start, stop]; }
  return [stop, start];
}

List d3_scaleRange(scale) {
  if (scale is Ordinal) {
    return scale.rangeExtent();
  }
  return d3_scaleExtent(scale.range);
}

class LinearScale extends Scale {
  List _domain = [0, 1];
  List _range = [0, 1];
  dynamic _interpolate = _interpolateNumber;
  bool _clamp = false;
  
  LinearScale() {
    _rescale();
  }
  
  Function _input, _output;
  
  Object call(dynamic d) => _output(d);
  
  void _rescale() {
    /*
    var linear = Math.min(domain.length, range.length) > 2 ? d3_scale_polylinear : d3_scale_bilinear,
        uninterpolate = clamp ? d3_uninterpolateClamp : d3_uninterpolateNumber;
    output = linear(domain, range, uninterpolate, interpolate);
    input = linear(range, domain, uninterpolate, d3_interpolate);
    return scale;
    */
    var uninterpolate = _uninterpolateNumber;
    var linear = _bilinear;
    _output = linear(_domain, _range, uninterpolate, _interpolate);
    _input = linear(_range, _domain, uninterpolate, _interpolateNumber);
  }
  
  List get range => _range;
  
  void set range(List value) {
    _range = value;
    _rescale();
  }
  
  void set domain(List value) {
    _domain = value;
    _rescale();
  }
  
  List get domain => _domain;
  
  List ticks(int m) => d3_scale_linearTicks(domain, m);
  
  List d3_scale_linearTicks(domain, m) {
    List r = d3_scale_linearTickRange(domain, m);
    return d3range(r[1], start: r[0], step: r[2]);
  }
  
  List d3_scale_linearTickRange(domain, m) {
    if (m == null) m = 10;

    var extent = d3_scaleExtent(domain),
        span = extent[1] - extent[0],
        step = Math.pow(10, (Math.log(span / m) / Math.LN10).floor()),
        err = m / span * step;

    // Filter ticks to get closer to the desired count.
    if (err <= .15) step *= 10;
    else if (err <= .35) step *= 5;
    else if (err <= .75) step *= 2;

    // Round start and stop values to step interval.
    extent[0] = (extent[0] / step).ceil() * step;
    extent[1] = (extent[1] / step).floor() * step + step * .5; // inclusive
    extent.add(step);
//    extent[2] = step;
    return extent;
  }
  
  void nice([m]) {
    d3_scale_linearNice(domain, m);
    _rescale();
  }
  
  List d3_scale_linearNice(domain, m) {
    return d3_scale_nice(domain, d3_scale_niceStep(d3_scale_linearTickRange(domain, m)[2]));
  }
}

List d3_scale_nice(domain, nice) {
  var i0 = 0,
      i1 = domain.length - 1,
      x0 = domain[i0],
      x1 = domain[i1],
      dx;

  if (x1 < x0) {
    dx = i0;
    i0 = i1;
    i1 = dx;
    dx = x0;
    x0 = x1;
    x1 = dx;
  }

  domain[i0] = nice["floor"](x0);
  domain[i1] = nice["ceil"](x1);
  return domain;
}

Map d3_scale_niceStep(step) {
  if (step != null) {
    return {
      "floor": (x) { return (x / step).floor() * step; },
      "ceil": (x) { return (x / step).ceil() * step; }
    };
  }
  return d3_scale_niceIdentity;
}

var d3_scale_niceIdentity = {
  "floor": (x) => x,
  "ceil": (x) => x
};

/*
 * 
 * 

var d3_scale_niceIdentity = {
  floor: d3_identity,
  ceil: d3_identity
};

 */
/*
d3.scale.linear = function() {
  return d3_scale_linear([0, 1], [0, 1], d3_interpolate, false);
};

function d3_scale_linear(domain, range, interpolate, clamp) {
  var output,
      input;

  function rescale() {
    var linear = Math.min(domain.length, range.length) > 2 ? d3_scale_polylinear : d3_scale_bilinear,
        uninterpolate = clamp ? d3_uninterpolateClamp : d3_uninterpolateNumber;
    output = linear(domain, range, uninterpolate, interpolate);
    input = linear(range, domain, uninterpolate, d3_interpolate);
    return scale;
  }

  function scale(x) {
    return output(x);
  }

  // Note: requires range is coercible to number!
  scale.invert = function(y) {
    return input(y);
  };

  scale.domain = function(x) {
    if (!arguments.length) return domain;
    domain = x.map(Number);
    return rescale();
  };

  scale.range = function(x) {
    if (!arguments.length) return range;
    range = x;
    return rescale();
  };

  scale.rangeRound = function(x) {
    return scale.range(x).interpolate(d3_interpolateRound);
  };

  scale.clamp = function(x) {
    if (!arguments.length) return clamp;
    clamp = x;
    return rescale();
  };

  scale.interpolate = function(x) {
    if (!arguments.length) return interpolate;
    interpolate = x;
    return rescale();
  };

  scale.ticks = function(m) {
    return d3_scale_linearTicks(domain, m);
  };

  scale.tickFormat = function(m, format) {
    return d3_scale_linearTickFormat(domain, m, format);
  };

  scale.nice = function(m) {
    d3_scale_linearNice(domain, m);
    return rescale();
  };

  scale.copy = function() {
    return d3_scale_linear(domain, range, interpolate, clamp);
  };

  return rescale();
}

function d3_scale_linearRebind(scale, linear) {
  return d3.rebind(scale, linear, "range", "rangeRound", "interpolate", "clamp");
}

function d3_scale_linearNice(domain, m) {
  return d3_scale_nice(domain, d3_scale_niceStep(d3_scale_linearTickRange(domain, m)[2]));
}

function d3_scale_linearTickRange(domain, m) {
  if (m == null) m = 10;

  var extent = d3_scaleExtent(domain),
      span = extent[1] - extent[0],
      step = Math.pow(10, Math.floor(Math.log(span / m) / Math.LN10)),
      err = m / span * step;

  // Filter ticks to get closer to the desired count.
  if (err <= .15) step *= 10;
  else if (err <= .35) step *= 5;
  else if (err <= .75) step *= 2;

  // Round start and stop values to step interval.
  extent[0] = Math.ceil(extent[0] / step) * step;
  extent[1] = Math.floor(extent[1] / step) * step + step * .5; // inclusive
  extent[2] = step;
  return extent;
}

function d3_scale_linearTicks(domain, m) {
  return d3.range.apply(d3, d3_scale_linearTickRange(domain, m));
}

function d3_scale_linearTickFormat(domain, m, format) {
  var precision = -Math.floor(Math.log(d3_scale_linearTickRange(domain, m)[2]) / Math.LN10 + .01);
  return d3.format(format
      ? format.replace(d3_format_re, function(a, b, c, d, e, f, g, h, i, j) { return [b, c, d, e, f, g, h, i || "." + (precision - (j === "%") * 2), j].join(""); })
      : ",." + precision + "f");
}
*/