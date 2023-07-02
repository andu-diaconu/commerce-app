class AddForeignKeys < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :favorites, :products
    add_foreign_key :favorites, :users
    add_foreign_key :product_carts, :carts
    add_foreign_key :product_carts, :products
    add_foreign_key :carts, :users
    add_foreign_key :reviews, :users
    add_foreign_key :reviews, :products
    add_foreign_key :product_orders, :orders
    add_foreign_key :product_orders, :products
    add_foreign_key :products, :brands
    add_foreign_key :orders, :users
    add_foreign_key :orders, :shipping_addresses
    add_foreign_key :orders, :billing_addresses
    add_foreign_key :orders, :credit_cards
    add_foreign_key :discounts, :brands
    add_foreign_key :shipping_addresses, :users
    add_foreign_key :billing_addresses, :users
    add_foreign_key :credit_cards, :users
    add_foreign_key :users, :brands
  end
end
