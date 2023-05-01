class ElectronicSensor < ApplicationRecord
  belongs_to :electronic
  belongs_to :function
end