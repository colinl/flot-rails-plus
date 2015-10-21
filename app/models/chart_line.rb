# Class to handle line definition on a Chart
class ChartLine
  attr_reader :tag, :color, :value_method, :options
  
  # constructor taking tag string, line colour and a getter method of Sample to get the value
  def initialize( tag, color, value_method, options={} )
    @tag = tag
    @color = color
    @value_method = value_method
    @options = options
  end
  
  # returns the values that are to be passed to the client browser, as a hash
  def as_hash
    {:tag => @tag, :color => @color, :value_method => @value_method, :options => @options}
  end
  
    # class method given an array of lines returns an array of value_methods (not necessarily unique)
  def self.value_methods( lines )
    lines.map { |l| l.value_method }
  end
  
end

