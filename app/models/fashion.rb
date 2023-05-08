class Fashion < ApplicationRecord
  belongs_to :product

  enum category: {"T-Shirt": 0, "Dress": 1, "Jeans": 2, "Shoes": 3, "Hoodie": 4}
end