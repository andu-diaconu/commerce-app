class Message < ApplicationRecord
  # belongs_to :sender, class_name: "User"
  # belongs_to :receiver, class_name: "User"
  after_create_commit { broadcast_append_to self.room }
  belongs_to :user
  belongs_to :room

  validates :content, presence: true
end