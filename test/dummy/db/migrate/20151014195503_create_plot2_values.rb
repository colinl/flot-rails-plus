class CreatePlot2Values < ActiveRecord::Migration
  def change
    create_table :plot2_values do |t|
      t.integer :x2
      t.float :v1_2
      t.float :v2_2
      
      t.timestamps null: false
    end
  end
end
