class Function < ApplicationRecord
  has_many :electronic_functions
  has_many :electronics, through: :electronic_functions
  has_many :entertainment_functions
  has_many :entertainments, through: :entertainment_functions
end