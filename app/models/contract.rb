class Contract < ApplicationRecord
  belongs_to :shop
  has_many :contractdetails, dependent: :destroy
  belongs_to :user
end
