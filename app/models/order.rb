class Order < ApplicationRecord
  has_many :orderdetails, dependent: :destroy
end
