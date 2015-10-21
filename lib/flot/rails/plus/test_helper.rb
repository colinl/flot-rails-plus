class ActiveSupport::TestCase  
  
  # call after requesting a page to extract gon.chart_sets as an array of ChartSets
  # where each ChartSet is a hash
  def fetch_flot_chart_sets
    chart_sets = nil
    assert_select "script", /gon\.chart_sets=/ do |element|
      # get the tag as a string
      string = element.to_s
      # select the gon.chart_sets string as $1
      string =~ /gon\.chart_sets=(.*\}\]);/
      # parse it as json
      chart_sets = JSON.parse $1
      # this should be an array of chart set hashes
    end
    chart_sets
  end
  
  # returns all charts from all sets
  def fetch_flot_charts
    chart_sets = fetch_flot_chart_sets
    charts = []
    chart_sets.each {|s| charts += s["charts"]}
    charts
  end
  
  # call after requesting a page to extract the chart for a given div
  # nil if not found
  def fetch_flot_chart_by_div( div )
    charts = fetch_flot_charts  # fetch all charts from all sets
    charts_for_div = charts.select { |c| c["div"] == div }
    charts_for_div.empty?  ?  nil  :  charts_for_div[0]
  end
    
  # call after requesting a readings page to extract gon.url
  def fetch_flot_callback_url
    url = nil
    assert_select "script", /gon\.url=/ do |element|
      # get the tag as a string
      string = element.to_s
      # select the gon.url string as $1
      string =~ /gon\.url=\"(.*?)\"/
      url = $1
    end
    url
  end
    
  # call after requesting a readings page to extract gon.refresh
  def fetch_flot_refresh
    refresh = nil
    assert_select "script", /gon\.refresh=/ do |element|
      # get the tag as a string
      string = element.to_s
      # select the gon.refresh string as $1
      string =~ /gon\.refresh=(.*?);/
      refresh = $1
    end
    refresh
  end
  
end
