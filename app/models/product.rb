class Product < ApplicationRecord
  has_many :electronics
  has_many :entertainments
  has_many :fashions
  has_many :product_carts
  has_many :favorites
  has_many :product_orders
  has_many :feedbacks
  belongs_to :brand
end