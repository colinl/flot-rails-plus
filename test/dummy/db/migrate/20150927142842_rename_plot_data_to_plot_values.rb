class RenamePlotDataToPlotValues < ActiveRecord::Migration
  def change
    rename_table :plot_data, :plot_values
  end
end
