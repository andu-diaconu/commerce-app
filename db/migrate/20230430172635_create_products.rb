class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false, default: ""
      t.text :description
      t.decimal :price, null: false, default: 10
      t.integer :stock, null: false, default: 10
      t.string :colour
      t.integer :brand_id

      t.timestamps
    end
  end
end
