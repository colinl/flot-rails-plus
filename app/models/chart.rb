# class to encapsulate the definition of a chart in browser
class Chart
  attr_reader :lines, :div, :options
  
  # constructor taking a div id and an array of Lines
  # options should contain :xaxis with :method
  # :xaxis may also contain :min and :max
  def initialize( div, lines, options = {} )
    @div = div
    @lines = lines
    @options = options
  end
      
  # returns the values that are to be passed to the client browser, as a hash, inluding the lines
  def as_hash
    {:div => @div, :lines => @lines.map { |l| l.as_hash }, :options => @options }
  end

  # class method, given an array of Charts, returns an array of unique value methods for the lines
  def self.value_methods( charts )
    charts.map { |c| ChartLine.value_methods( c.lines ) }.flatten.uniq
  end
  
end
