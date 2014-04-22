part of D3Dart;

abstract class ChartWithAxes {
  num width;
  num height;

  bool has_legend = false;
  String yAxisLabel = "y Axis";
  Map margin = {"top": 20, "right": 20, "bottom": 250, "left": 50};
  Function yAxisTickFormat;
  
  void renderXAxis(var x, var g) {
    var xAxis = new Axis();
    xAxis.scale = x;
    xAxis.orient = "bottom";

    var gx = g.append("g");
    gx.attr("class", "x axis");
    gx.attr("transform", "translate(0,${height})");
    gx.call(xAxis);
    var gx_text = gx.selectAll("text");
    gx_text.attr("transform", "rotate(-65)");
    gx_text.style.textAnchorConst = "end";
    gx_text.attr("dx", "-1em");
    gx_text.attr("dy", "0em");
  }
  
  void renderGridlines(LinearScale y, var g) {
    // First render gridlines
    var ggridlines = g.append("g");
    ggridlines.attr("class", "ygridlines");
    BoundSelection tick = ggridlines.selectAll(".gridline").data(y.ticks(10)/*, key: scale1 */);
    var tickEnter = tick.enter.append("g");
    tickEnter.attr("class", "gridline");
    tickEnter.append("line");
    tickEnter.attrFunc("transform", (d, i) => "translate(0, ${y(d)})");
    var lineEnter = tickEnter.select("line");
    lineEnter.attr("x2", width);
  }
  
  void renderYAxis(LinearScale y, var g) {
    var yAxis = new Axis();
    yAxis.scale = y;
    yAxis.orient = "left";
    
    yAxis.tickFormat = yAxisTickFormat;
    
    // Then axis
    var gy = g.append("g");
    gy.attr("class", "y axis");
    gy.call(yAxis);
    
    var gl = gy.append("text");
    gl.attr("transform", "rotate(-90)");
    gl.attr("y", 6);
    gl.attr("dy", ".71em");
    gl.style.textAnchorConst = "end";
    gl.text = yAxisLabel;
  }
  
  void renderLegend(Element $elmt, var _data, var color) {
    if (has_legend) {
      var legend_div = selectElement($elmt).append("div");
      legend_div.attr("class", "legend");
      legend_div.style.widthConst = "${margin['right'] - 5}px";
      BoundSelection sel = legend_div.selectAll(".legend-item").data(_data);
      Selection legend_item = sel.enter.append("div");
      legend_item.attr("class", "legend-item clearfix");
      
      Selection legend_key = legend_item.append("div");
      legend_key.attr("class", "legend-key");
      legend_key.style.backgroundColor = (d, i) {
        return "#${color(d.first['y']).toRadixString(16)}";
      };

      Selection legend_label = legend_item.append("div");
      legend_label.textFunc = (d, i) {
        return d.first['y'].toString();
      };
    }
  }
}

class _ColumnPopover extends _Popover {
  
  var margin;
  var x;
  var y;
  
  _ColumnPopover(Element $elmt, num width, num height, var this.margin, var this.x, var this.y) : super($elmt, null, width, height) {
    
  }
  
  void position(Object d) {
    $popover_title.text = (d as Map)['x'].toString();
    
    Rectangle rect = $hover.getBoundingClientRect();
    int xoff = (x((d as Map)['x']) + margin['left'] - rect.width).floor();
    int yoff = (y((d as Map)['stack_end']) + margin['top'] - (rect.height / 2)).floor();

    $hover.style.left = "${xoff}px";
    $hover.style.top = "${yoff}px";
  }
}

class ColumnChart extends ChartWithAxes {
  
  Element $elmt;
  
  num initial_width;
  num initial_height;
  
  var color = Scale.category10;
  
  List _data;
  
  bool is_stacked = true;
  
  var popoverContentFunc;

  ColumnChart(Element this.$elmt, { int this.initial_width, int this.initial_height }) {
    Rectangle rect = $elmt.getBoundingClientRect();
    if (width == null) {
      initial_width = rect.width;
    }
    if (height == null) {
      initial_height = rect.height;
    }
  }
  
  void _render() {
    width = initial_width - margin["left"] - margin["right"];
    height = initial_height - margin["top"] - margin["bottom"];
    
    var x = new Ordinal();
    x.rangeRoundBands([0, width], padding: 0.1);
    
    var y = new LinearScale();
    y.range = [height, 0];
    
    var svg = selectElement($elmt).append("svg");
    svg.attr("width", width +  margin["left"] + margin["right"]);
    svg.attr("height", height + margin["top"] + margin["bottom"]);

    var g = svg.append("g");
    g.attr("transform", "translate(${margin["left"]},${margin["top"]})");
    
    if (is_stacked) {
      List last_series_total = [];
      for (int i = 0; i < _data.first.length; i += 1) {
        last_series_total.add(0);
      }
      for (List series in _data) {
        int i = 0;
        for (Map d in series) {
          num v = last_series_total[i];
          d['stack_start'] = v;
          v += d['value'];
          d['stack_end'] = v;
          last_series_total[i] = v;
          i += 1;
        }
      }
    }
    
    var series1 = _data[0];
    x.domain = series1.map((Map d) {
      return d["x"];
    }).toList();
    
    var y_extent = [0, 0.01];
    for (List series in _data) {
      var extents = extent(series, (d,i) {
        num v = d["stack_end"];
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
    
    int index = 0;
    List<Selection> rects = [];
    for (List series in _data) {
      EnterSelection bar = g.selectAll(".bar${index}")
         .data(series)
       .enter;

      Selection rect = bar.append("rect");
      rect
         .attr("class", "bar${index}");
      rect
         .attrFunc("x", (d,i) { return x(d["x"]); });
      rect
         .attr("width", x.rangeBand);
      
      rect
         .attrFunc("y", (d,i) { return y(d["stack_end"]); });
      rect
         .attrFunc("height", (d,i) { return y(d["stack_start"]) - y(d["stack_end"]); });
      
      rect.style.fill = (Object d, int i) => "#${(color((d as Map)["y"]) as int).toRadixString(16)}";
      rects.add(rect);
      index += 1;
    }

    // Ontop of data
    renderYAxis(y, g);
    renderLegend($elmt, _data, color);

    if (popoverContentFunc != null) {
      _ColumnPopover hover = new _ColumnPopover($elmt, width, height, margin, x, y);
      hover.popoverContentFunc = popoverContentFunc;
          
      for (Selection rect in rects) {
        rect.onMouseOver.listen((MouseEvent evt) {
          var sel = selectElement(evt.target);
          Object datum = sel.datum;
          if (datum != null) {
            hover.datum = datum;
          }
        });
      }
      
      $elmt.onMouseLeave.listen((_) {
        hover.datum = null;
      });
    }
  }
  
  void set data(List value) {
    _data = value;
    _render();
  }
}
