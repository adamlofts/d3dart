part of D3Dart;

typedef String PopoverTitleFunc(dynamic d);

class _Popover {
  
  PopoverTitleFunc popoverTitleFunc;
  var popoverContentFunc;
  
  Object _datum;
  
  Element $hover = new DivElement();
  Element $popover_title = new DivElement();
  Element $content_value = new DivElement();
    
  Arc arc;
  num width;
  num height;
  
  bool is_left = true;
  
  _Popover(Element $elmt, Arc this.arc, num this.width, num this.height) {
    DivElement $arrow = new DivElement();
    $arrow.classes.add("arrow");
    $hover.append($arrow);
    
    $popover_title.classes.add("popover-title");
    $hover.append($popover_title);
    
    Element $content = new DivElement();
    $content.classes.add("popover-content");
    $content.append($content_value);
    $hover.append($content);
    
    $elmt.append($hover);
    
    $hover.classes.addAll(const ["chart-hover", "popover"]);
    if (is_left) {
      $hover.classes.add("left");
    } else {
      $hover.classes.add("right");
    }
  }
  
  void position(Object d) {
    Map data = (d as Map)['data'];
    
    String title;
    if (popoverTitleFunc != null) {
      title = popoverTitleFunc(d);
    } else {
      title = data['x'].toString();
    }
    $popover_title.text = title;
    
    List centroid = arc.centroid(d, null);
    Rectangle rect = $hover.getBoundingClientRect();
    int x = (centroid[0].toInt() + (width / 2)).floor();
    if (is_left) {
      x -= rect.width.floor();
    }
    int y = (centroid[1].toInt() + (height / 2) - (rect.height / 2)).floor();
    $hover.style.left = "${x}px";
    $hover.style.top = "${y}px";

  }
  
  void set datum(Object d) {
    if (d == _datum) {
      return;
    }
    _datum = d;  
    if (d == null) {
      $hover.style.display = "none";
      return;
    }

    // Set display and content first so we compute popover bounds correctly
    $hover.style.display = "block";
    
    Node node = $content_value.firstChild;
    if (node != null) {
      $content_value.firstChild.remove();
    }
    $content_value.append(popoverContentFunc(d));
    position(d);
  }
}

class PieChart {
  
  Element $elmt;
  
  num initial_width;
  num initial_height;
  
  var color = Scale.category10;
  
  List _data;
  
  Map margin = { "top": 5, "right": 5, "bottom": 5, "left": 5 };

  num innerRadiusPercent = 0;
  num outerRadiusPercent = 1;
  
  bool has_legend = false;
  bool has_segment_labels = false;
  bool is_hide_small_segment_labels = true;
  
  var popoverContentFunc;
  PopoverTitleFunc popoverTitleFunc;

  DivElement $title = new DivElement();
  
  PieChart(Element this.$elmt, { int this.initial_width, int this.initial_height }) {
    Rectangle rect = $elmt.getBoundingClientRect();
    if (initial_width == null) {
      initial_width = rect.width;
    }
    if (initial_height == null) {
      initial_height = rect.height;
    }
  }
  
  void _render() {
    num width = initial_width - margin["left"] - margin["right"];
    num height = initial_height - margin["top"] - margin["bottom"];
        
    num radius = Math.min(width, height) / 2;
    
    Arc arc = new Arc();
    arc.outerRadiusConst = (radius - 10) * outerRadiusPercent;
    arc.innerRadiusConst = (radius - 10) * innerRadiusPercent;
    
    Selection svg = selectElement($elmt).append("svg")
        ..attr("width", width)
        ..attr("height", height);
    
    svg = svg.append("g");
    svg.attr("transform", "translate(${width / 2},${height / 2})");
    
    PieLayout pie = Layout.pie();
    pie.value = (Map d) => d["value"];
    
    var enterSelection = svg.selectAll(".arc")
        .data(pie(_data))
        .enter;
    
    var g = enterSelection.append("g");
    g.attr("class", "arc");
    
    var path = g.append("path");
    path.attrFunc("d", arc);

    path.style.fill = (Object d, int i) => colorToHex(color(i));
    
    if (has_segment_labels) {
      var g2 = enterSelection.append("g");
      var text = g2.append("text");
      text.attrFunc("transform", (Object d, int i) => "translate(${ arc.centroid(d, i).join(",") })");
      text.attr("dy", ".35em");
      
      text.style.textAnchor = (d, i) => "middle";
      text.textFunc = (d, i) {
        if (is_hide_small_segment_labels) {
          if ((d["endAngle"] - d["startAngle"]) < 0.01) {
            return "";
          }
        }
        return d["data"]["x"];
      };
    }

    if (has_legend) {
      var legend_div = selectElement($elmt).append("div");
      legend_div.attr("class", "legend");
      BoundSelection sel = legend_div.selectAll(".legend-item").data(_data);
      Selection legend_item = sel.enter.append("div");
      legend_item.attr("class", "legend-item clearfix");

      Selection legend_key = legend_item.append("div");
      legend_key.attr("class", "legend-key");
      legend_key.style.backgroundColor = (d, i) => colorToHex(color(i));
      Selection legend_label = legend_item.append("div");
      legend_label.textFunc = (d, i) {
        return d['x'].toString();
      };
    }
    
    $title.classes.add("chart-title");
    $elmt.append($title);
    
    if (popoverContentFunc != null) {
      _Popover hover = new _Popover($elmt, arc, width, height);
      hover.popoverTitleFunc = popoverTitleFunc;
      hover.popoverContentFunc = popoverContentFunc;
          
      path.onMouseOver.listen((MouseEvent evt) {
        var sel = selectElement(evt.target);
        Object datum = sel.datum;
        if (datum != null) {
          hover.datum = datum;
        }
      });
      
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