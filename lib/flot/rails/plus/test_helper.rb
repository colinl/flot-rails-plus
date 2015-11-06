class ActiveSupport::TestCase  
  
  # Call after requesting a page to extract the chart sets as an array of ChartSets
  # where each ChartSet is a hash.
  def fetch_flot_chart_sets
    chart_sets = nil
    assert_select "script", /gon\.chart_sets=/ do |element|
      # get the tag as a string
      string = element[0].to_s
      # select the gon.chart_sets string as $1
      string =~ /gon\.chart_sets=(.*\}\]);/
      # parse it as json
      chart_sets = JSON.parse $1
      # this should be an array of chart set hashes
    end
    chart_sets
  end
  
  # Call after requesting a page to extract all charts from all sets.
  # The result is an array of hashes.
  def fetch_flot_charts
    chart_sets = fetch_flot_chart_sets
    charts = []
    chart_sets.each {|s| charts += s["charts"]}
    charts
  end
  
  # Call after requesting a page to extract the chart for a given div.
  # Returns nil if not found.
  def fetch_flot_chart_by_div( div )
    charts = fetch_flot_charts  # fetch all charts from all sets
    charts_for_div = charts.select { |c| c["div"] == div }
    charts_for_div.empty?  ?  nil  :  charts_for_div[0]
  end
    
  # Call after requesting a page to extract the json callback url.
  def fetch_flot_callback_url
    url = nil
    assert_select "script", /gon\.url=/ do |element|
      # get the tag as a string
      string = element[0].to_s
      # select the gon.url string as $1
      string =~ /gon\.url=\"(.*?)\"/
      url = $1
    end
    url
  end
    
  # Call after requesting a readings page to extract the refresh repeat time.
  def fetch_flot_refresh
    refresh = nil
    assert_select "script", /gon\.refresh=/ do |element|
      # get the tag as a string
      string = element[0].to_s
      # select the gon.refresh string as $1
      string =~ /gon\.refresh=(.*?);/
      refresh = $1
    end
    refresh
  end
  
end
