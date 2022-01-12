class Appointproduct < ApplicationRecord
  has_many :appointproductdetails, dependent: :destroy
end
