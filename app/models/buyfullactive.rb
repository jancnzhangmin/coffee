class Buyfullactive < ApplicationRecord
  has_many :buyfullactivedetails, dependent: :destroy
end
