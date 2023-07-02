class Room < ApplicationRecord
  validates_uniqueness_of :name
  after_create_commit {broadcast_append_to "rooms"}
  has_many :messages
end