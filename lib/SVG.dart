
part of D3Dart;

typedef num ArcFunction(Object d, int i);

class Arc {
  static const num _arcOffset = -HALF_PI;
  static const num _arcMax = TWO_PI - EPSILON;

  ArcFunction innerRadius = (Object d, int i) => (d as Map)["innerRadius"];
  ArcFunction outerRadius = (Object d, int i) => (d as Map)["outerRadius"];
  ArcFunction startAngle = (Object d, int i) => (d as Map)["startAngle"];
  ArcFunction endAngle = (Object d, int i) => (d as Map)["endAngle"];
  
  void set innerRadiusConst(num value) {
    innerRadius = (Object d, int i) => value;
  }
  
  void set outerRadiusConst(num value) {
    outerRadius = (Object d, int i) => value;
  }
  
  void set startAngleConst(num value) {
    startAngle = (Object d, int i) => value;
  }
  
  void set endAngleConst(num value) {
    endAngle = (Object d, int i) => value;
  }
  
  List<int> centroid(Object d, int i) {
    num r = (innerRadius(d, i) + outerRadius(d, i)) / 2;
    num a = (startAngle(d, i) + endAngle(d, i)) / 2 + _arcOffset;
    return [Math.cos(a) * r, Math.sin(a) * r];
  }
  
  String call(dynamic d, int i) {
    num r0 = innerRadius(d, i),
        r1 = outerRadius(d, i),
        a0 = startAngle(d, i) + _arcOffset,
        a1 = endAngle(d, i) + _arcOffset;
    
    num da;
    if (a1 < a0) {
      da = a0;
      a0 = a1;
      a1 = da;
    } else {
      da = a1 - a0;
    }
    
    String df = (da < Math.PI) ? "0" : "1";
    num c0 = Math.cos(a0),
        s0 = Math.sin(a0),
        c1 = Math.cos(a1),
        s1 = Math.sin(a1);
    
    return da >= _arcMax
      ? ((r0 != 0)
      ? "M0,${r1}"
      + "A${r1},${r1} 0 1,1 0, ${-r1}"
      + "A${r1},${r1} 0 1,1 0,${r1}"
      + "M0,${r0}"
      + "A${r0},${r0} 0 1,0 0,${-r0}"
      + "A${r0},${r0} 0 1,0 0,${r0}"
      + "Z"
      : "M0,${r1}"
      + "A${r1},${r1} 0 1,1 0,${-r1}"
      + "A${r1},${r1} 0 1,1 0,${r1}"
      + "Z")
      : ((r0 != 0)
      ? "M${r1 * c0},${r1 * s0}"
      + "A${r1},${r1} 0 ${df},1 ${r1 * c1},${r1 * s1}"
      + "L${r0 * c1},${r0 * s1}"
      + "A${r0},${r0} 0 ${df},0 ${r0 * c0},${r0 * s0}"
      + "Z"
      : "M${r1 * c0},${r1 * s0}"
      + "A${r1},${r1} 0 ${df},1 ${r1 * c1},${r1 * s1}"
      + "L0,0"
      + "Z");
  }
}
