
refresh_timeout_timer = null

# default options in case user has not provided them
options = {
    series: { 
        lines: { show: true, lineWidth: 2 }, # for some reason shadowSize here does not work, had to put in line options
        points: {
            radius: 1,
            show: false
        }
    }
    xaxis: {}
    yaxis: {min: -10, max: 30},
    legend: {"backgroundOpacity":0.0,"position":"sw"},
    grid: {"autoHighlight":false,"hoverable":true},
    crosshair: {"mode":"x"}    
};

$(document).ready () ->
  if gon? &&  gon.chart_sets
    # merge our default options into the chart options
    mergeOptions()
    # draw the charts the first time if sample data has been provided
    doRefreshChart(gon.chart_sets)
    # run ajax update loop if requested
    refreshChart()
  
mergeOptions =->
  # merges default options into gon.charts, with priority for those in gon.charts
  for chart_set in gon.chart_sets
    for chart in chart_set['charts']
      # make a deep clone of the options
      cloned_options = jQuery.extend( true, {}, options )
      #alert cloned_options['xaxis']
      # merge in gon.charts options in
      jQuery.extend( true, cloned_options, chart['options'] )
      # and set the chart options to that
      chart['options'] = cloned_options

refreshChart = ->
  if gon.url?
    # a json url has been supplied get plot data via ajax
    url = gon.url
    $.ajax url,
      type : 'GET',
      dataType : 'json',
      success : (data) ->
        chart_sets = data["chart_sets"]
        # merge in chart configuration from gon
        for chart_set, index in chart_sets
          chart_set["charts"] = gon.chart_sets[index]["charts"]
        doRefreshChart(chart_sets)
      error : (XMLHttpRequest, textStatus, errorThrown) ->
        #alert( "Ajax error" )
      complete : () ->
        # if auto refresh was requested then set the timer 
        if gon.refresh  &&  gon.refresh > 0
          # clear the timer before restarting 
          clearTimeout( refresh_timeout_timer )
          refresh_timeout_timer = setTimeout(refreshChart, gon.refresh * 1000)
      
doRefreshChart = (chart_sets) ->
  for chart_set in chart_sets
    # nothing to do if no samples provided
    if chart_set['samples']
      # setup array containing div and channel name for each line and array for data
      linerefs = []
      xaxismethod = chart_set['xaxis']['method']
      xaxismode = chart_set['xaxis']['mode']
      for chart, index in chart_set['charts']
        div = chart['div']
        # merge timerange from json data into the chart options
        for k,v of chart_set['xaxis']
          chart['options']['xaxis'][k] = v 
        for line in chart['lines']
          lineref = {div: div, chart_index: index, tag: "#{line['tag']}=_____", \
            value_method: line['value_method'], color: line['color'], options: line['options'], datapoints: []}
          linerefs.push lineref
      # extract datapoints for each line
      for sample in chart_set['samples']
        x = sample[xaxismethod]
        if xaxismode == 'time'
          x = new Date(x).getTime()
        for ref in linerefs
          #alert "x #{x} v #{sample[ref['value_method']]}"
          ref['datapoints'].push( [x, sample[ref['value_method']]] )
  
      # setup datasets for each div
      datasets = {}
      for lineref in linerefs
        thisset = {label: lineref['tag'], color: lineref['color'], shadowSize: 0, data: lineref['datapoints']}
        # deep merge in the line options
        jQuery.extend true, thisset, lineref['options']
        (datasets[lineref['chart_index']] = datasets[lineref['chart_index']] || []).push( thisset )
      plots = []
      legends = []
      divs = []
      for chart_index,dataset of datasets
        chart = chart_set['charts'][chart_index]
        div = chart["div"]
        # plot the chart
        plot = jQuery.plot($("##{div}"), dataset, chart["options"])
        #if this is the first draw of this div then setup the update function
        div_id = document.getElementById(div)
        if !div_id.plot
          # first time through so plot the chart 
          # and save the plot object and legends in a custom property of the div
          div_id.plot = jQuery.plot($("##{div}"), dataset, chart["options"])
          div_id.legends = fix_legends( div )
          # and bind to the hover event
          $("##{div}").bind "plothover", (event, pos, item) =>
            hoverHandler event, pos, item
        else
          # not first time so just update the data
          div_id.plot.setData dataset
          div_id.plot.draw()
          # and refresh the legends object
          div_id.legends = fix_legends( div )

hoverHandler = (event, pos, item) ->
  if (!updateLegendTimeout)
    updateLegendTimeout = setTimeout (=> timeoutFn(event, pos, item) ), 50
    
timeoutFn = (event, pos, item) ->
  updateLegend(event.target.plot, event.target.legends, pos)
