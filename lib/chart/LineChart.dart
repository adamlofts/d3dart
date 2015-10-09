part of D3Dart;

class LineChart extends ChartWithAxes {
  
  Element $elmt;
  
  var color = Scale.category10;
  
  List _data;
  
  num initial_width;
  num initial_height;
  
  LineChart(Element this.$elmt, { int this.initial_width, int this.initial_height }) {
    Rectangle rect = $elmt.getBoundingClientRect();
    if (initial_width == null) {
      initial_width = rect.width;
    }
    if (initial_height == null) {
      initial_height = rect.height;
    }
  }
  
  void _render() {
    width = initial_width - margin["left"] - margin["right"];
    height = initial_height - margin["top"] - margin["bottom"];
    
    var x = new Ordinal();
    x.rangePoints([0, width], padding: 0.1);
    
    var y = new LinearScale();
    y.range = [height, 0];
    
    var svg = selectElement($elmt).append("svg");
    svg.attr("width", width +  margin["left"] + margin["right"]);
    svg.attr("height", height + margin["top"] + margin["bottom"]);

    var g = svg.append("g");
    g.attr("transform", "translate(${margin["left"]},${margin["top"]})");
    
    var series1 = _data[0];
    x.domain = series1.map((Map d) {
      return d["x"];
    }).toList();
    
    var y_extent = [0, 1e-6];
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
    
   // Below data
   renderXAxis(x, g);
   renderGridlines(y, g);
    
    var line = new Line();
    line.defined = (d, i) {
      num v = d["value"];
      return !(v.isNaN || v.isInfinite);
    };
    line.x = (d, i) => x(d["x"]);
    line.y = (d, i) => y(d["value"]);
    
    for (List series in _data) {
      var path = g.append("path");
      path.attr("class", "line");
      path.datum = series;

      path.attrFunc("stroke", (d,i) => colorToHex(color(d.first['y'])));
      path.attrFunc("d", line);
    }
    
    renderYAxis(y, g);
    renderLegend($elmt, _data, color);
  }
  
  void set data(List value) {
    _data = value;
    _render();
  }
}
