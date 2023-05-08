class Package < ApplicationRecord
  has_many :entertainment_packages
  has_many :entertainments, through: :entertainment_packages
end