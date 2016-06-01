part of D3Dart;

abstract class ChartWithAxes {
  num width;
  num height;

  bool has_legend = false;
  bool has_gridlines = true;
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
      legend_key.style.backgroundColor = (d, i) => colorToHex(color(d.first['y']));

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
  final bool is_stacked;
  final num bar_width;
  
  _ColumnPopover(Element $elmt, num width, num height, var this.margin, var this.x, var this.y, bool this.is_stacked, num this.bar_width) : 
    super($elmt, null, width, height);
  
  void position(Object _d) {
    Map d = _d as Map;
    
    String title;
    if (popoverTitleFunc != null) {
      title = popoverTitleFunc(d);
    } else {
      title = d['x'].toString();
    }
    $popover_title.text = title;
    
    Rectangle rect = $hover.getBoundingClientRect();
    int xoff;
    int yoff;
    
    if (is_stacked) {
      xoff = (x(d['x']) + margin['left'] - rect.width).floor();
      // Position popover in middle of bar
      yoff = (y(d['stack_end']) + (y(0) - y(d['value'])) / 2 + margin['top'] - (rect.height / 2)).floor();
    } else {
      xoff = (x(d['x']) + d['series_index'] * bar_width + margin['left'] - rect.width).floor();
      yoff = (y(d['value']) + margin['top'] - (rect.height / 2)).floor();
    }

    // Never position outside the viewport
    xoff = Math.max(0, xoff);
    
    $hover.style.left = "${xoff}px";
    $hover.style.top = "${yoff}px";
  }
}

class ItemClickEvent {
  final Object datum;
  final Selection selection;
  final MouseEvent evt;
  const ItemClickEvent(MouseEvent this.evt, Selection this.selection, Object this.datum);
}

class ColumnChart extends ChartWithAxes {
  
  final StreamController<ItemClickEvent> _onItemClick = new StreamController<ItemClickEvent>.broadcast();
  Stream<ItemClickEvent> get onItemClick => _onItemClick.stream;
  
  Element $elmt;
  
  num initial_width;
  num initial_height;
  
  var color = Scale.category10;
  
  List _data;
  List _dataReversed;

  bool is_stacked = true;
  
  var popoverContentFunc;
  PopoverTitleFunc popoverTitleFunc;
  
  num column_padding = 0.1;
  
  ColumnChart(Element this.$elmt, { int this.initial_width, int this.initial_height }) {
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
    x.rangeRoundBands([0, width], padding: Math.max(column_padding, 0.01));
    
    var y = new LinearScale();
    y.range = [height, 0];
    
    var svg = selectElement($elmt).append("svg");
    svg.attr("width", width +  margin["left"] + margin["right"]);
    svg.attr("height", height + margin["top"] + margin["bottom"]);

    var g = svg.append("g");
    g.attr("transform", "translate(${margin["left"]},${margin["top"]})");
    
    List last_series_total = [];
    List last_series_total_neg = [];
    for (int i = 0; i < _data.first.length; i += 1) {
      last_series_total.add(0);
      last_series_total_neg.add(0);
    }
    int series_index = 0;
    for (List series in _data) {
      int i = 0;
      for (Map d in series) {
        num v = last_series_total[i];
        num v_neg = last_series_total_neg[i];
        d['series_index'] = series_index;
        if (d['value'] >= 0) {
          d['stack_start'] = v;
          v += d['value'];
          d['stack_end'] = v;
        } else {
          d['stack_end'] = v_neg;
          v_neg += d['value'];
          d['stack_start'] = v_neg;
        }
        
        last_series_total[i] = v;
        last_series_total_neg[i] = v_neg;
        i += 1;
      }
      series_index += 1;
    }
    
    var series1 = _data[0];
    x.domain = series1.map((Map d) {
      return d["x"];
    }).toList();
    
    var y_extent = [0, 1e-6];
    for (List series in _data) {
      var extents = extent(series, (d,i) {
        num v;
        if (is_stacked) {
          if (d["value"] >= 0) {
            v = d["stack_end"];
          } else {
            v = d["stack_start"];
          }
        } else {
          v = d["value"];
        }
        
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
    
    if (has_gridlines) {
      renderGridlines(y, g);
    }
    
    num bar_width;
    if (is_stacked) {
      bar_width = x.rangeBand;
    } else {
      bar_width = x.rangeBand / _data.length;
    }
          
    int index = 0;
    List<Selection> rects = [];
    for (List series in _data) {
      EnterSelection bar = g.selectAll(".bar${index}")
         .data(series)
       .enter;

      Selection rect = bar.append("rect");
      rect.attr("class", "bar${index}");
      
      if (is_stacked) {
        rect.attrFunc("x", (d, i) { return x(d["x"]); });
      } else {
        rect.attrFunc("x", (d, i) { return x(d["x"]) + bar_width * d["series_index"]; });
      }
      rect.attr("width", bar_width);
      
      if (is_stacked) {
        rect.attrFunc("y", (d,i) {
          num v = d["stack_end"];
          if (v.isInfinite || v.isNaN || v < 0) {
            v = 0;
          }
          return y(v);
        });
        rect.attrFunc("height", (d, i) {
          num v = d["stack_end"];
          if (v.isInfinite || v.isNaN || v < 0) {
            v = 0;
          }
          num v1 = d["stack_start"];
          if (v1.isInfinite || v1.isNaN || v1 < 0) {
            v1 = 0;
          }
          return y(v1) - y(v);
        });
      } else {
        rect.attrFunc("y", (d, i) {
          num v = d["value"];
          if (v.isInfinite || v.isNaN || v < 0) {
            v = 0;
          }
          return y(v);
        });
        rect.attrFunc("height", (d, i) {
          num v = d["value"];
          if (v.isInfinite || v.isNaN || v < 0) {
            v = 0;
          }
          num h = y(0) - y(v);
          return h.abs();
        });
      }

      rect.style.fill = (Object d, int i) => colorToHex(color((d as Map)['y']));

      rects.add(rect);
      index += 1;
    }

    // Ontop of data
    renderYAxis(y, g);

    List legendData = _data;
    if (is_stacked) {  // If stacked then legend should be reversed.
      legendData = _dataReversed;
    }
    renderLegend($elmt, legendData, color);

    if (popoverContentFunc != null) {
      _ColumnPopover hover = new _ColumnPopover($elmt, width, height, margin, x, y, is_stacked, bar_width);
      hover.popoverContentFunc = popoverContentFunc;
      hover.popoverTitleFunc = popoverTitleFunc;
          
      for (Selection rect in rects) {
        rect.onMouseOver.listen((MouseEvent evt) {
          var sel = selectElement(evt.target);
          Object datum = sel.datum;
          if (datum != null) {
            hover.datum = datum;
          }
        });
        rect.onClick.listen((MouseEvent evt) {
          var sel = selectElement(evt.target);
          Object datum = sel.datum;
          _onItemClick.add(new ItemClickEvent(evt, sel, datum));
        });
      }
      
      $elmt.onMouseLeave.listen((_) {
        hover.datum = null;
      });
    }
  }
  
  void set data(List value) {
    _data = value;
    if (is_stacked) {
      _dataReversed = new List.from(value.reversed);
    }
    _render();
  }
}
