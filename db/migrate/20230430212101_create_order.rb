class CreateOrder < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.decimal :subtotal
      t.decimal :shipping_tax
      t.integer :discount_id
      t.decimal :total
      t.string :payment_method
      t.string :delivery_method
      t.integer :user_id
      t.integer :shipping_address_id
      t.integer :billing_address_id
      t.integer :credit_card_id

      t.timestamps
    end
  end
end
