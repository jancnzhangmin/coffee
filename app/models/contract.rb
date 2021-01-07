class Contract < ApplicationRecord
  belongs_to :shop
  has_many :contractdetails, dependent: :destroy
end
