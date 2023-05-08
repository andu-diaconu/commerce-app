class CreateEntertainment < ActiveRecord::Migration[7.0]
  def change
    create_table :entertainments do |t|
      t.string :memory
      t.string :edition
      t.integer :controllers
      t.float :weight
      t.string :production_year
      t.integer :category
      t.integer :product_id
      t.references :entertainment_function, foreign_key: true
      t.references :entertainment_package, foreign_key: true
      
      t.timestamps
    end
  end
end
