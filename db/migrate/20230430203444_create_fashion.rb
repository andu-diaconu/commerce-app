class CreateFashion < ActiveRecord::Migration[7.0]
  def change
    create_table :fashions do |t|
      t.string :size
      t.string :sex
      t.string :season
      t.string :model
      t.string :material
      t.string :close_system
      t.string :style
      t.integer :category
      t.integer :product_id

      t.timestamps
    end
  end
end
