class Electronic < ApplicationRecord
  has_many :electronic_sensors
  has_many :sensors, through: :electronic_sensors
  has_many :electronic_functions
  has_many :functions, through: :electronic_functions
  belongs_to :product

  enum category: {"Apple Watch": 0, "Smart Watch": 1, "Laptop": 2, "Android Phone": 3, "iOS Phone": 4}
end