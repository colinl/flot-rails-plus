module PlotValuesHelper
  
  LINE_V1 = ChartLine.new( "v1", "#c30000", :v1)
  LINE_V2 = ChartLine.new( "v2", "#00ff00", :v2)
  LINE_V1_2 = ChartLine.new( "v1", "#0000c3", :v1_2)
  LINE_V2_2 = ChartLine.new( "v2", "#808000", :v2_2)
  
  # given an array of plot_data objects sets up charts and tells flot-rails-plus to prepare the data for the index view
  # pass :json => json from view builder to generate json for chart population via json callback
  # url option is used to pass requirement for error conditions for testing
  def setup_charts( plot_values, url_option, options = {} )
    # the chart definition
    chart = Chart.new( "flot_chart_div", [LINE_V1, LINE_V2],
      yaxis: {min: -1, max: 1} )
    charts = [chart]
    xaxis = {method: :timestamp, mode: "time"}
    # check for passed options used for testing the gem
    if url_option == "no_xaxis"
      xaxis = nil
    end
    if url_option == "no_xaxis_method"
      xaxis[:method] = nil
    end
    chart_set = ChartSet.new( charts, plot_values, xaxis )
    setup_flot_view [chart_set], options
  end
  
    # given an array of plot_data objects sets up charts and tells flot-rails-plus to prepare the data for page2 view
  def setup_charts_page2( plot_values, options = {} )
    # the chart definition
    chart = Chart.new( "flot_chart_div2", [LINE_V1, LINE_V2],
      yaxis: {min: -1, max: 1} )
    charts = [chart]
    chart_set = ChartSet.new( charts, plot_values, {method: :x} )
    setup_flot_view [chart_set], options
  end  
  
  # sets up charts and tells flot-rails-plus to prepare the data for page3 view
  # plot_values may be nil in call from view as the data will be provided when called from json builder
  # the url for json callback should be in :url option
  def setup_charts_page3( plot_values, options = {} )
    # the chart definitions
    chart1 = Chart.new( "flot_chart_div3_1", [LINE_V1, LINE_V2],
      yaxis: {min: -1, max: 1} )
    chart2 = Chart.new( "flot_chart_div3_2", [LINE_V1],
      yaxis: {min: -1, max: 10} )
    charts = [chart1,chart2]
    chart_set = ChartSet.new( charts, plot_values, {method: :x} )
    setup_flot_view [chart_set], options
  end
  
  # given an array of plot_data objects sets up charts and tells flot-rails-plus to prepare the data for page2 view
  def setup_charts_page4( plot_values, options = {} )
    # the chart definition
    chart = Chart.new( "flot_chart_div4", [LINE_V1, LINE_V2],
      yaxis: {min: -1, max: 1} )
    charts = [chart]
    chart_set = ChartSet.new( charts, plot_values, {method: :x, min: -10, max: 10} )
    setup_flot_view [chart_set], options
  end
  
  # given an array of plot_data objects sets up charts and tells flot-rails-plus to prepare the data for page2 view
  def setup_charts_page5( plot_values, options = {} )
    # the chart definition
    chart = Chart.new( "flot_chart_div5", [LINE_V1, LINE_V2],
      xaxis: {method: :timestamp, mode: "time", min: "2015-09-15 08:00:00".to_time(:utc), max: "2015-09-18 10:00:00".to_time(:utc)},
      yaxis: {min: -1, max: 1} )
    charts = [chart]
    chart_set = ChartSet.new( charts, plot_values, 
      {method: :timestamp, mode: "time", min: "2015-09-15 08:00:00".to_time(:utc), max: "2015-09-18 10:00:00".to_time(:utc)} )
    setup_flot_view [chart_set], options
  end 
  
  # given an array of plot_data objects and array of plot2_data objects sets up charts and 
  # tells flot-rails-plus to prepare the data for page6 view
  def setup_charts_page6( plot_values, plot2_values )
    # the chart definition
    chart1 = Chart.new( "flot_chart_div6_1", [LINE_V1],
      yaxis: {min: -1, max: 1} )
    chart2 = Chart.new( "flot_chart_div6_2", [LINE_V2],
      yaxis: {min: -1, max: 1} )
    chart3 = Chart.new( "flot_chart_div6_3", [LINE_V1_2],
      yaxis: {min: 0, max: 1000} )
    chart4 = Chart.new( "flot_chart_div6_4", [LINE_V2_2],
      yaxis: {min: 0, max: 1000} )
    chart_set1 = ChartSet.new( [chart1, chart2], plot_values, 
      {method: :timestamp, mode: "time", min: "2015-09-15 08:00:00".to_time(:utc), max: "2015-09-18 10:00:00".to_time(:utc)} )
    chart_set2 = ChartSet.new( [chart3, chart4], plot2_values, 
      {method: :x2} )
    setup_flot_view [chart_set1, chart_set2]
  end 
  
  # given an array of plot_data objects and array of plot2_data objects sets up charts and 
  # tells flot-rails-plus to prepare the data for page7 view
  def setup_charts_page7( plot_values, plot2_values, options = {} )
    # the chart definition
    chart1 = Chart.new( "flot_chart_div7_1", [LINE_V1],
      yaxis: {min: -1, max: 1} )
    chart2 = Chart.new( "flot_chart_div7_2", [LINE_V2],
      yaxis: {min: -1, max: 1} )
    chart3 = Chart.new( "flot_chart_div7_3", [LINE_V1_2],
      yaxis: {min: 0, max: 1000} )
    chart4 = Chart.new( "flot_chart_div7_4", [LINE_V2_2],
      yaxis: {min: 0, max: 1000} )
    chart_set1 = ChartSet.new( [chart1, chart2], plot_values, 
      {method: :timestamp, mode: "time", min: "2015-09-15 08:00:00".to_time(:utc), max: "2015-09-18 10:00:00".to_time(:utc)} )
    chart_set2 = ChartSet.new( [chart3, chart4], plot2_values, 
      {method: :x2} )
    setup_flot_view [chart_set1, chart_set2], options
  end 
  
end
