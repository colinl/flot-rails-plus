module FlotViewHelpers
  # called by application to setup the view for display or the json for callback data
  # for html leave options blank, for json pass the json object from the view builder 
  # as :json => json
  # to enable that also pass :url as the full url to use for json callback in the initial
  # call from the view, in which case samples may be nil as they will be picked up via 
  # json call after initial view has been rendered.
  def setup_flot_view( chart_sets, options = {} )
    if options[:json]
      build_json chart_sets, options
    else
      build_gon chart_sets, options
    end
  end
  
  def build_gon( chart_sets, options = {} )
    gon.url = options[:url]
    gon.refresh = options[:refresh]
    gon.chart_sets = chart_sets.map { |c| c.as_hash }
    
    # generate gon data that will appear in the view
    include_gon
  end    
  
  def build_json( chart_sets, options )
    json = options[:json]
    json.chart_sets chart_sets.map{ |c| c.as_hash(:with_charts => false) } 
  end
    
end

ActionView::Base.send :include, FlotViewHelpers
  # allow access to gon methods from view helpers
ActionController::Base.send :helper_method, :gon
