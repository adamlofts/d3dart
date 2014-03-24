part of D3Dart;

class LineChart {
  
  Element $elmt;
  
  num width;
  num height;
  
  Ordinal color = Scale.category10;
  
  List _data;
  
  Map margin = {"top": 20, "right": 20, "bottom": 50, "left": 50};

  LineChart(Element this.$elmt, { int this.width, int this.height }) {
    Rectangle rect = $elmt.getBoundingClientRect();
    if (width == null) {
      width = rect.width;
    }
    if (height == null) {
      height = rect.height;
    }
  }
  
  void _render() {
    var width = this.width - margin["left"] - margin["right"],
        height = this.height - margin["top"] - margin["bottom"];
    
    var x = new Ordinal();
    x.rangePoints([0, width], padding: 0.1);
    
    var xAxis = new Axis();
    xAxis.scale = x;
    xAxis.orient = "bottom";
    
    var y = new LinearScale();
    y.range = [height, 0];
    
    var yAxis = new Axis();
    yAxis.scale = y;
    yAxis.orient = "left";
    
    var svg = selectElement($elmt).append("svg");
    svg.attr("width", width +  margin["left"] + margin["right"]);
    svg.attr("height", height + margin["top"] + margin["bottom"]);

    var g = svg.append("g");
    g.attr("transform", "translate(${margin["left"]},${margin["top"]})");
    
    var series1 = _data[0];
    x.domain = series1.map((Map d) {
      return d["x"];
    }).toList();
    
    var y_extent = [0, 1];
    for (List series in _data) {
      var extents = extent(series, (d,i) {
        num v = d["value"];
        if (v.isNaN || v.isInfinite) {
          v = 0;
        }
        return v;
      });
      y_extent[0] = Math.min(y_extent[0], extents[0]);
      y_extent[1] = Math.max(y_extent[1], extents[1]);
    }
    
    y.domain = y_extent;
    
    var gx = g.append("g");
    gx.attr("class", "x axis");
    gx.attr("transform", "translate(0,${height})");
    gx.call(xAxis);
    
    var gy = g.append("g");
    gy.attr("class", "y axis");
    gy.call(yAxis);
    
    var gl = gy.append("text");
    gl.attr("transform", "rotate(-90)");
    gl.attr("y", 6);
    gl.attr("dy", ".71em");
    gl.style.textAnchorConst = "end";
    gl.text = "CO2e (g)";
    
    
    var line = new Line();
    line.x = (d, i) => x(d["x"]);
    line.y = (d, i) {
      num v = d["value"];
      if (v.isNaN || v.isInfinite) {
        v = 0;
      }
      return y(v);
    };
    
    int index = 0;
    for (List series in _data) {
      var path = g.append("path");
      path.datum = series;
      path.attr("class", "line${index}");
      path.attrFunc("d", line);
      index = 1;
    }
  }
  
  void set data(List value) {
    _data = value;
    _render();
  }
}
