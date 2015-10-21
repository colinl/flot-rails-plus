require 'test_helper'

class ChartSetTest < ActiveSupport::TestCase
  
  def test_as_hash_returns_correct_data
    lines = [ ChartLine.new( "v1", "#000000", :v1 ),
    ChartLine.new( "v2", "#ffffff", :v2 ) ]
    chart = Chart.new( "thediv", lines )
    chart_set = ChartSet.new( [chart, chart], PlotValue.all, 
      {:method => :timestamp, :mode => "time", :ticks => 23, :timeformat => "%H%M"} )
    hash = chart_set.as_hash
    assert_equal 2, hash[:charts].length
    assert_equal "thediv", hash[:charts][0][:div]
    assert_equal 2, hash[:charts][1][:lines].length
    assert_equal "#ffffff",hash[:charts][0][:lines][1][:color]
    assert_equal 4, hash[:samples].length
    assert_equal "%H%M", hash[:xaxis][:timeformat]
  end
  
end
