class Brand < ApplicationRecord
  has_many :users
  has_many :products
  has_many :discounts
end