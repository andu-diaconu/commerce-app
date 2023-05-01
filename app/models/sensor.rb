class Sensor < ApplicationRecord
  has_many :electronic_sensors
  has_many :electronics, through: :electronic_sensors
end