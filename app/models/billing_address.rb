class BillingAddress < ApplicationRecord
  has_many :orders
  belongs_to :user, optional: true
end