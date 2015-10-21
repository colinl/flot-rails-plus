require 'test_helper'

class ChartTest < ActiveSupport::TestCase

  def test_constructor_should_setup_attributes
    lines = [ ChartLine.new( "t1", "#000000", :t_internal ),
    ChartLine.new( "t2", "#ffffff", :t_external ),
    ChartLine.new( "t3", "#0f0f0f", :rain_total ) ]
    chart = Chart.new( "thediv", lines, :xaxis => {:ticks => 23, :timeformat => "%H%M"} )
    assert_equal "thediv", chart.div
    chart_lines = chart.lines
    assert_equal 3, chart_lines.length
    assert_equal "t2", chart_lines[1].tag
    assert_equal 23, chart.options[:xaxis][:ticks]
  end
  
  def test_as_hash_returns_correct_data
    lines = [ ChartLine.new( "t1", "#000000", :t_internal ),
    ChartLine.new( "t2", "#ffffff", :t_external ),
    ChartLine.new( "t3", "#0f0f0f", :rain_total ) ]
    chart = Chart.new( "thediv", lines, :xaxis => {:ticks => 23, :timeformat => "%H%M"} )
    hash = chart.as_hash
    assert_equal "thediv", hash[:div]
    assert_equal 3, hash[:lines].length
    assert_equal "#0f0f0f",hash[:lines][2][:color]
    assert_equal "%H%M", hash[:options][:xaxis][:timeformat]
  end
  
  def test_value_methods_returns_unique_array
    line_t_int = ChartLine.new( "t1", "#000000", :t_internal )
    line_t_ext = ChartLine.new( "t2", "#ffffff", :t_external )
    line_rain = ChartLine.new( "t3", "#0f0f0f", :rain_total )
    lines1 = [line_t_int, line_t_ext]
    lines2 = [line_t_ext, line_rain]
    charts = [Chart.new( "div1", lines1, :xaxis => {:method => :time} ), Chart.new("div1", lines2)]
    methods = Chart.value_methods charts
    assert_equal 3, methods.length
    [:t_internal, :t_external, :rain_total].each do |m|
      assert methods.include?(m), "methods does not include #{m}"
    end
  end
  
end

