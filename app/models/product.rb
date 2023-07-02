class Product < ApplicationRecord
  has_many :product_carts
  has_many :favorites
  has_many :product_orders
  has_many :reviews
  has_many :product_categories
  has_many :customer
  has_many :user_ratings
  belongs_to :brand
  mount_uploader :image, ImageUploader

end