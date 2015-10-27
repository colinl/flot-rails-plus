# A ChartSet is a set of charts which all appear on the same view, have the same x axis
# and whose values all come from the same collection.
# Often the collection will be the result of an ActiveRecord query.
# The value_method specified for a line may be a field from the database or may be 
# any method on the ActiveRecord derived class which returns a value to be plotted.
class ChartSet
  # class which is a set of charts to be shown on a page where the chars draw their data from 
  # the same dataset and are shown with the same recordset
  attr_reader :charts, :xaxis, :samples, :options     # :nodoc:

  # Constructor
  #
  # === Attributes
  #
  # * +charts+ - An array of Charts
  # * +collection+ - A collection containing data to be plotted.  Often this will be an ActiveRecord query.
  #   This may be nil if ajax will be used to fetch the data
  # * +xaxis - A hash defining the method to be used to get the xaxis value, and other flot xaxis options.
  #
  # === Examples
  #
  #   chart_set1 = new ChartSet( [chart1, chart2], Values.all, {method: x} )
  #   chart_set2 = new ChartSet( [chart3, chart4], Samples.where(...), {method: :timestamp, mode: "time", min: "2015-09-15 08:00:00".to_time(:utc), max: "2015-09-18 10:00:00".to_time(:utc) } )
  #  
  def initialize( charts, collection, xaxis )
    @charts = charts
    @samples = collection
    @xaxis = xaxis
    begin
      method = @xaxis[:method]
    rescue
      raise "Flot-rails-plus error: xaxis is not a hash"
    end
    if method == nil
      raise "Flot-rails-plus error: xaxis[:method] is nil"
    end
  end
  
  # returns the values that are to be passed to the client browser, as a hash
  # if with_charts is passed false then only samples and xaxis are included
  def as_hash( options = {:with_charts => true} )   # :nodoc:
    samples_mapped = nil
    if @samples
      samples_mapped = @samples.map do |r|
        Hash[(Chart.value_methods(@charts) << @xaxis[:method]).map { |v| [v, r.send(v)] }]
      end
    end
    # fill in xaxis range if not supplied
    xaxis = @xaxis
    xaxis_method = xaxis[:method]
    if @samples && @samples.length > 0
      if xaxis[:mode] == "time"    # may be nil if none provided
        # if min and max have been provided by chart they must be scaled accordingly
        xaxis[:min] ||= @samples.first.send(xaxis_method)
        xaxis[:min] = xaxis[:min].to_i*1000
        xaxis[:max] ||= @samples.last.send(xaxis_method)
        xaxis[:max] = xaxis[:max].to_i*1000
      else
        xaxis[:min] ||= @samples.first.send(xaxis_method)
        xaxis[:max] ||= @samples.last.send(xaxis_method)
      end
    end
    hash = {:samples => samples_mapped, :xaxis => xaxis }
    if options[:with_charts] != false
      # add the chart definitions if required
      hash[:charts] = @charts.map {|c| c.as_hash }
    end
    hash
  end
  
end
