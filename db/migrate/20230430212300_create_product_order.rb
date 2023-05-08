class CreateProductOrder < ActiveRecord::Migration[7.0]
  def change
    create_table :product_orders do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
