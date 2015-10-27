# A Chart represents a chart to be drawn in a div in the view
class Chart
  attr_reader :lines, :div, :options    # :nodoc:
  
  # Constructor.
  #
  # === Attributes
  #
  # * +div+ - A string containing the id of the div to contain the chart
  # * +lines+ - An array of ChartLines to be shown on the chart
  # * +options+ - Optional, allows chart options available in the flot library to be specified
  #
  # === Examples
  #
  #   chart1 = Chart.new( "chart1", [chart_line1], yaxis: {min: 0, max: 10} )
  #   chart2 = Chart.new( "chart2", [chart_line1,chart_line2], yaxis: {min: 0, max: 10}, y2axis: {min: 900, max: 1100} )
  #
  def initialize( div, lines, options = {} )
    @div = div
    @lines = lines
    @options = options
  end
      
  # returns the values that are to be passed to the client browser, as a hash, inluding the lines
  def as_hash   # :nodoc:
    {:div => @div, :lines => @lines.map { |l| l.as_hash }, :options => @options }
  end

  # class method, given an array of Charts, returns an array of unique value methods for the lines
  def self.value_methods( charts )    # :nodoc:
    charts.map { |c| ChartLine.value_methods( c.lines ) }.flatten.uniq
  end
  
end
