
part of D3Dart;

class Axis {
  
  Scale scale;
  
  String orient = "bottom";
  num innerTickSize = 6,
      outerTickSize = 6,
      tickPadding = 3;
 
  List tickArguments_ = [10];
  var tickValues = null;
  var tickFormat;
  
  void call(Selection g) {
    g.each((Element elmt, dynamic d, int i, [int j]) {
      var g = selectElement(elmt);

      // Stash a snapshot of the new scale, and retrieve the old snapshot.
      //var scale0 = this.__chart__ || scale,
      //    scale1 = this.__chart__ = scale.copy();
      
      var scale1 = scale;
      
      var ticks;
      if (tickValues != null) {
        ticks = tickValues;
      } else {
        if (scale is LinearScale) {
          ticks = (scale as LinearScale).ticks(tickArguments_[0]);
        } else {
          ticks = scale1.domain;
        } 
      }
      BoundSelection tick = g.selectAll(".tick").data(ticks/*, key: scale1 */);

      var tickFormatFunc; 
      if (tickFormat != null) {
        tickFormatFunc = tickFormat;
      } else {
        /*if (scale1.tickFormat) {
          
        } else {*/
        tickFormatFunc = (d, int i) => d.toString(); 
        //}
      }
      // Ticks, or domain values for ordinal scales.
      /*var ticks = tickValues == null ? (scale1.ticks ? scale1.ticks.apply(scale1, tickArguments_) : scale1.domain()) : tickValues,
          tickFormat = tickFormat_ == null ? (scale1.tickFormat ? scale1.tickFormat.apply(scale1, tickArguments_) : d3_identity) : tickFormat_,
          tick = g.selectAll(".tick").data(ticks, scale1),
          tickEnter = tick.enter().insert("g", ".domain").attr("class", "tick").style("opacity", ε),
          tickExit = d3.transition(tick.exit()).style("opacity", ε).remove(),
          tickUpdate = d3.transition(tick).style("opacity", 1),
          tickTransform;
          */
      
      var tickEnter = tick.enter.append("g");
      var tickUpdate = new Selection.copy(tick);
      tickEnter.attr("class", "tick");
      var tickTransform;
      
      // Domain.
      var range = d3_scaleRange(scale1),
          path = g.selectAll(".domain").data([0]),
          pathUpdate = path.enter.append("path");
          
      pathUpdate.attr("class", "domain");
      // pathUpdate
      tickEnter.append("line");
      tickEnter.append("text");

      var lineEnter = tickEnter.select("line"),
          lineUpdate = tickUpdate.select("line"),
          text = tickEnter.select("text"); // FIXME: tick.select("text")
      text.textFunc = tickFormatFunc;
      var textEnter = tickEnter.select("text"),
        textUpdate = tickUpdate.select("text");


      if (orient == "bottom") {
        tickTransform = d3_svg_axisX;
        lineEnter.attr("y2", innerTickSize);
        textEnter.attr("y", Math.max(innerTickSize, 0) + tickPadding);
        lineUpdate.attr("x2", 0);
        lineUpdate.attr("y2", innerTickSize);
        textUpdate.attr("x", 0);
        textUpdate.attr("y", Math.max(innerTickSize, 0) + tickPadding);
        text.attr("dy", ".71em");
        text.style.textAnchorConst = "middle";
        pathUpdate.attr("d", "M${range[0]},${outerTickSize}V0H${range[1]}V${outerTickSize}");
      } else if (orient == "top") {
        tickTransform = d3_svg_axisX;
        lineEnter.attr("y2", -innerTickSize);
        textEnter.attr("y", -(Math.max(innerTickSize, 0) + tickPadding));
        lineUpdate.attr("x2", 0);
        lineUpdate.attr("y2", -innerTickSize);
        textUpdate.attr("x", 0);
        textUpdate.attr("y", -(Math.max(innerTickSize, 0) + tickPadding));
        text.attr("dy", "0em");
        text.style.textAnchorConst = "middle";
        // pathUpdate.attr("d", "M" + range[0] + "," + -outerTickSize + "V0H" + range[1] + "V" + -outerTickSize);
      } else if (orient == "left") {
        tickTransform = d3_svg_axisY;
        lineEnter.attr("x2", -innerTickSize);
        textEnter.attr("x", -(Math.max(innerTickSize, 0) + tickPadding));
        lineUpdate.attr("x2", -innerTickSize);
        lineUpdate.attr("y2", 0);
        textUpdate.attr("x", -(Math.max(innerTickSize, 0) + tickPadding));
        textUpdate.attr("y", 0);
        text.attr("dy", ".32em");
        text.style.textAnchorConst = "end";
        pathUpdate.attr("d", "M${-outerTickSize},${range[0]}H0V${range[1]}H${-outerTickSize}");
      } else {
        tickTransform = d3_svg_axisY;
        lineEnter.attr("x2", innerTickSize);
        textEnter.attr("x", Math.max(innerTickSize, 0) + tickPadding);
        lineUpdate.attr("x2", innerTickSize);
        lineUpdate.attr("y2", 0);
        textUpdate.attr("x", Math.max(innerTickSize, 0) + tickPadding);
        textUpdate.attr("y", 0);
        text.attr("dy", ".32em");
        text.style.textAnchorConst = "start";
        pathUpdate.attr("d", "M${outerTickSize},${range[0]}H0V${range[1]}H${outerTickSize}");
      }

      // For ordinal scales:
      // - any entering ticks are undefined in the old scale
      // - any exiting ticks are undefined in the new scale
      // Therefore, we only need to transition updating ticks.
      if (scale1 is Ordinal) {
        num dx = scale1.rangeBand / 2;
        Function x = (d) => scale1(d) + dx;
        tickTransform(tickEnter, x);
        tickTransform(tickUpdate, x);
      }

      // For quantitative scales:
      // - enter new ticks from the old scale
      // - exit old ticks to the new scale
      else {
        tickTransform(tickEnter, scale1);

        //tickEnter.call(tickTransform, scale0);
        tickTransform(tickUpdate, scale1);
        //tickUpdate.call(tickTransform, scale1);
        //tickExit.call(tickTransform, scale1);
      }
    });
  }
  
  void d3_svg_axisX(selection, x) {
    selection.attrFunc("transform", (d, i) => "translate(${x(d)},0)");
  }
  
  void d3_svg_axisY(selection, y) {
    selection.attrFunc("transform", (d, i) => "translate(0, ${y(d)})");
  }
}
