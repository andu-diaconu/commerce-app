class Function < ApplicationRecord
  has_many :electronic_functions
  has_many :electronics, through: :electronic_functions
end