class CreatePlotData < ActiveRecord::Migration
  def change
    create_table :plot_data do |t|
      t.float :x
      t.datetime :timestamp
      t.float :v1
      t.float :v2
      t.integer :v3
      
      t.timestamps
    end
  end
end
