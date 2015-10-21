class ChartSet
  # class which is a set of charts to be shown on a page where the chars draw their data from 
  # the same dataset and are shown with the same recordset
  attr_reader :charts, :xaxis, :samples, :options

  # constructor taking an array of Charts, an array of samples (which may be nil) 
  # and a hash specifying the xaxis options
  # xaxis should specify at least :method
  # the samples may be nil if ajax will be used to fetch the data
  def initialize( charts, samples, xaxis )
    @charts = charts
    @samples = samples
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
  def as_hash( options = {:with_charts => true} )
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
