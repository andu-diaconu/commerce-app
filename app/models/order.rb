class Order < ApplicationRecord
  belongs_to :user
  belongs_to :shipping_address
  belongs_to :billing_address
  belongs_to :credit_card, optional: true
  belongs_to :discount, optional: true
  has_many :product_orders
end