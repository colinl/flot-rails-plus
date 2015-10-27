# A ChartLine is a line which is to appear on a chart (or several charts).
class ChartLine
  attr_reader :tag, :color, :value_method, :options     # :nodoc:
  
  # Constructor
  #
  # === Attributes
  #
  # * +tag+ - A string used to identify the line
  # * +color+ - The line color
  # * +value_method+ - A symbol representing the method that is to be used to fetch the individual values for the line
  # * +options+ - Optional, allows line options available in the flot library to be specified
  #
  # === Examples
  #
  #   chart_line1 = ChartLine.new( "t1", "#ff0000", :temperature_1 )
  #   chart_line2 = ChartLine.new( "pressure", "#00ff00", :pressure, lines: {show: false}, bars: => {show: true}, yaxis: 2 )
  #
  def initialize( tag, color, value_method, options={} )
    @tag = tag
    @color = color
    @value_method = value_method
    @options = options
  end
  
  # returns the values that are to be passed to the client browser, as a hash
  def as_hash     # :nodoc:
    {:tag => @tag, :color => @color, :value_method => @value_method, :options => @options}
  end
  
    # class method given an array of lines returns an array of value_methods (not necessarily unique)
  def self.value_methods( lines )   # :nodoc:
    lines.map { |l| l.value_method }
  end
  
end

