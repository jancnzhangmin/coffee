class Shop < ApplicationRecord
  acts_as_mappable
  has_many :contracts, dependent: :destroy
  has_and_belongs_to_many :shopclas
  has_many :shopimgs, dependent: :destroy
  has_many :shopusers, dependent: :destroy
end
