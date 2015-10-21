class PlotValuesController < ApplicationController
  protect_from_forgery
  
  # GET /plot_values
  def index
    @plot_values = PlotValue.order(:timestamp).all
    @url_option = params[:option]
  end
  
  #GET /plot_values/page2
  def page2
    @plot_values = PlotValue.order(:timestamp).all
  end
  
  #GET /plot_values/page3
  def page3
    @plot_values = PlotValue.order(:timestamp).all
  end
  
  #GET /plot_values/page4
  def page4
    @plot_values = PlotValue.order(:timestamp).all
  end
  
  #GET /plot_values/page5
  def page5
    @plot_values = PlotValue.order(:timestamp).all
  end
  
  #GET /plot_values/page6
  def page6
    @plot_values = PlotValue.order(:timestamp).all
    @plot2_values = Plot2Value.order(:x2).all
  end
    
  #GET /plot_values/page6
  def page7
    @plot_values = PlotValue.order(:timestamp).all
    @plot2_values = Plot2Value.order(:x2).all
  end
end
