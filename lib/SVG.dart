
part of D3Dart;

typedef num ArcFunction(Object d, int i);

class Arc {
  
  static const num _arcOffset = HALF_PI;
  static const num _arcMax = HALF_PI - EPSILON;

  ArcFunction _innerRadius;
  ArcFunction _outerRadius;
  ArcFunction _startAngle;
  ArcFunction _endAngle;
  
  void set innerRadius(num value) {
    _innerRadius = (Object d, int i) => value;
  }
  
  void set outerRadius(num value) {
    _outerRadius = (Object d, int i) => value;
  }
  
  void set startAngle(num value) {
    _startAngle = (Object d, int i) => value;
  }
  
  void set endAngle(num value) {
    _endAngle = (Object d, int i) => value;
  }
  
  List<int> centroid(Object d, int i) {
    num r = (_innerRadius(d, i) + _outerRadius(d, i)) / 2;
    num a = (_startAngle(d, i) + _endAngle(d, i)) / 2 + _arcOffset;
    return [Math.cos(a) * r, Math.sin(a) * r];
  }
}
