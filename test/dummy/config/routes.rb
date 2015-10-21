Rails.application.routes.draw do
  
  get 'plot_values/page1' => 'plot_values#index'
  get 'plot_values/page2' => 'plot_values#page2'
  get 'plot_values/page3' => 'plot_values#page3'
  get 'plot_values/page4' => 'plot_values#page4'
  get 'plot_values/page5' => 'plot_values#page5'
  get 'plot_values/page6' => 'plot_values#page6'
  get 'plot_values/page7' => 'plot_values#page7'
  
  root 'plot_values#index'
end
