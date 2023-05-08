class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :product_carts
end