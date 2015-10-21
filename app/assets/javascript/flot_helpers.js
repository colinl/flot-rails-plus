// Stuff added to customise flot for our use

var updateLegendTimeout = null;

function updateLegend(this_plot, plot_legends, pos) {
  updateLegendTimeout = null;
  
  var axes = this_plot.getAxes();
  if (pos.x < axes.xaxis.min || pos.x > axes.xaxis.max ||
    pos.y < axes.yaxis.min || pos.y > axes.yaxis.max)
  return;
  
  var i, j, dataset = this_plot.getData();
  for (i = 0; i < dataset.length; ++i) {
    var series = dataset[i];
    
    // find the first point after pos, x-wise
    for (j = 0; j < series.data.length; ++j)
      if (series.data[j][0] > pos.x)
      break;
    
    // use the previous value if not exact
    var y, y_text, p1 = series.data[j - 1], p2 = series.data[j];
    if (p1 == null)
      y = p2[1];
    else
      y = p1[1];

    if (y == null)
      y_text = "____";
    else
      y_text = y.toFixed(1);
    plot_legends.eq(i).text(series.label.replace(/=.*/, "= " + y_text));
  }
}

function fix_legends( div ) {
  var legends = $("#" + div + " .legendLabel");
  legends.each(function () {
      // fix the widths so they don't jump around
      $(this).css('width', $(this).width());
  });
  return legends;
}

