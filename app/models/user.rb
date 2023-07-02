class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable, :timeout_in => 2.hours

  enum role: {"Client":0, "Admin": 1, "Staff": 2}

  has_many :messages
  has_many :orders
  belongs_to :feedback, optional: true
  belongs_to :brand, optional: true
  has_one :credit_card
  has_one :shipping_address
  has_one :billing_address
  has_many :reviews
  has_many :customers
  has_many :user_ratings
  mount_uploader :image, ImageUploader

  scope :all_except, ->(user) { where.not(id: user) }
  after_create_commit { broadcast_append_to "users" }

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def client?
    self.role == "Client"
  end

  def staff?
    self.present? && self.role == "Staff"
  end

  def admin?
    self.present? && self.role == "Admin"
  end
end
