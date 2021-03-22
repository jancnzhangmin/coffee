class Order < ApplicationRecord
  has_many :orderdetails, dependent: :destroy
  belongs_to :user
end
