class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.text :name, null: false, default: ""
      t.text :description, default: ""
      t.string :label_name, default: ""
      t.decimal :price, null: false, default: 10
      t.integer :stock, null: false, default: 10
      t.decimal :rating, default: 0
      t.integer :rating_count, default: 0
      t.integer :brand_id
      t.string :identifier, null: false, unque: true
      t.string :image
      
      t.timestamps
    end
  end
end
