
part of D3Dart;

typedef Object InterpolateFunction(Object t);

InterpolateFunction _interpolateNumber(num a, num b) {
  b -= a;
  return (Object t) => a + b * t;
}

InterpolateFunction _uninterpolateNumber(num a, num b) {
  b = ((b - a) != 0) ? 1 / (b - a) : 0;
  return (x) => (x - a) * b;
}
/*
function d3_uninterpolateClamp(a, b) {
  b = b - (a = +a) ? 1 / (b - a) : 0;
  return function(x) { return Math.max(0, Math.min(1, (x - a) * b)); };
}
*/