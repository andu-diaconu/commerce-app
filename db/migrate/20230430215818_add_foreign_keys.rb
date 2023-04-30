class AddForeignKeys < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :electronics, :products
    add_foreign_key :entertainments, :products
    add_foreign_key :fashions, :products
    add_foreign_key :favorites, :products
    add_foreign_key :favorites, :users
    add_foreign_key :product_carts, :carts
    add_foreign_key :product_carts, :products
    add_foreign_key :carts, :users
    add_foreign_key :feedbacks, :users
    add_foreign_key :feedbacks, :products
    add_foreign_key :product_orders, :orders
    add_foreign_key :product_orders, :products
    add_foreign_key :products, :brands
    add_foreign_key :orders, :users
    add_foreign_key :orders, :shipping_addresses
    add_foreign_key :orders, :billing_addresses
    add_foreign_key :orders, :credit_cards
    add_foreign_key :discounts, :brands
    add_foreign_key :users, :shipping_addresses
    add_foreign_key :users, :billing_addresses
    add_foreign_key :users, :credit_cards
    add_foreign_key :users, :brands
  end
end
