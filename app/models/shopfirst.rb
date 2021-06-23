class Shopfirst < ApplicationRecord
  has_many :shopfirstdetails, dependent: :destroy
end
