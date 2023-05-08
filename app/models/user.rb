class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable, :timeout_in => 2.hours

  enum role: {"Client":0, "Admin": 1, "Staff": 2}

  has_many :sent_messages, foreign_key: :sender_id, class_name: "Message"
  has_many :received_messages, foreign_key: :receiver_id, class_name: "Message"
  has_many :orders
  belongs_to :feedback, optional: true
  belongs_to :brand, optional: true
  has_one :credit_card
  has_one :shipping_address
  has_one :billing_address
end
