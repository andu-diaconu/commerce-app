class Entertainment < ApplicationRecord
  has_many :entertainment_packages
  has_many :packages, through: :entertainment_packages
  has_many :entertainment_functions
  has_many :functions, through: :entertainment_functions
  belongs_to :product

  enum category: {"PlayStation": 0, "Xbox": 1, "Nintendo": 2, "Game": 3}
end