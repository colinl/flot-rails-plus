module FlotViewHelpers
  
  # Called by application to setup the view for display or the json for callback data.
  #
  # ==== Attributes
  #
  # * +chart_sets+ - Array of the ChartSets to be shown or updated
  # * +options+ - For html view leave options empty.  
  # * +options+ - For json callback pass the json object from the view builder as json: json
  #
  # ==== Examples
  # 
  # When called from view:
  #    setup_flot_view [chart_set_1, chart_set_2]
  # When called from json view builder
  #    setup_flot_view [chart_set_1, chart_set_2], json: json
  #
  def setup_flot_view( chart_sets, options = {} )
    if options[:json]
      build_json chart_sets, options
    else
      build_gon chart_sets, options
    end
  end
  
  def build_gon( chart_sets, options = {} )   # :nodoc:
    gon.url = options[:url]
    gon.refresh = options[:refresh]
    gon.chart_sets = chart_sets.map { |c| c.as_hash }
    
    # generate gon data that will appear in the view
    include_gon
  end    
  
  def build_json( chart_sets, options )   # :nodoc:
    json = options[:json]
    json.chart_sets chart_sets.map{ |c| c.as_hash(:with_charts => false) } 
  end
    
end

ActionView::Base.send :include, FlotViewHelpers
  # allow access to gon methods from view helpers
ActionController::Base.send :helper_method, :gon
