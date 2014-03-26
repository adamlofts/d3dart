part of D3Dart;

class PieChart {
  
  Element $elmt;
  
  num width;
  num height;
  
  var color = Scale.category10;
  
  List _data;
  
  num innerRadiusPercent = 0;
  num outerRadiusPercent = 1;
  
  bool has_legend = false;
  
  PieChart(Element this.$elmt, { int this.width, int this.height }) {
    Rectangle rect = $elmt.getBoundingClientRect();
    if (width == null) {
      width = rect.width;
    }
    if (height == null) {
      height = rect.height;
    }
  }
  
  void _render() {
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
    
    var g = svg.selectAll(".arc")
        .data(pie(_data))
        .enter.append("g");
    
    g.attr("class", "arc");
      
    var path = g.append("path");
    path.attrFunc("d", arc);
    path.style.fill = (Object d, int i) => "#${(color(i) as int).toRadixString(16)}";
    
    var text = g.append("text");
    text.attrFunc("transform", (Object d, int i) => "translate(${ arc.centroid(d, i).join(",") })");
    text.attr("dy", ".35em");
    
    text.style.textAnchor = (d, i) => "middle";
    text.textFunc = (d, i) => d["data"]["name"];
    
    text.attrFunc("display", (Map d, i) { // Hide label for small wedges
      if ((d["endAngle"] - d["startAngle"]) < 0.01) {
        return "none";
      }
      return "";
    });


    if (has_legend) {
      var legend_div = selectElement($elmt).append("div");
      legend_div.attr("class", "legend");
      BoundSelection sel = legend_div.selectAll(".legend-item").data(_data);
      Selection legend_item = sel.enter.append("div");
      legend_item.attr("class", "legend-item clearfix");

      Selection legend_key = legend_item.append("div");
      legend_key.attr("class", "legend-key");
      legend_key.style.backgroundColor = (d, i) {
        return "#${color(i).toRadixString(16)}";
      };
      Selection legend_label = legend_item.append("div");
      legend_label.textFunc = (d, i) {
        return d['x'].toString();
      };
    }
  }
  
  void set data(List value) {
    _data = value;
    _render();
  }
}