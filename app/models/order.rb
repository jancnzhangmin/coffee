class Order < ApplicationRecord
  has_many :orderdetails, dependent: :destroy
  belongs_to :user
  has_many :orderdelivers, dependent: :destroy
end
