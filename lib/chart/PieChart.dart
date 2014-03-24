part of D3Dart;

class PieChart {
  
  Element $elmt;
  
  num width;
  num height;
  
  Ordinal color = Scale.category10;
  
  List _data;
  
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
    arc.outerRadiusConst = radius - 10;
    arc.innerRadiusConst = 0;
    
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
  }
  
  void set data(List value) {
    _data = value;
    _render();
  }
}