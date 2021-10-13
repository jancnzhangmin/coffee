class Order < ApplicationRecord
  has_many :orderdetails, dependent: :destroy
  belongs_to :user
  has_many :orderdelivers, dependent: :destroy
  has_one :orderinvoice, dependent: :destroy
  has_many :aftersales, dependent: :destroy
end
