class Product < ApplicationRecord
  has_and_belongs_to_many :productexplains
  has_and_belongs_to_many :productclas
  has_many :productbanners, dependent: :destroy
  has_many :showparams, dependent: :destroy
  has_many :posters, dependent: :destroy
  has_and_belongs_to_many :banners
  has_many :orderdetails
  has_and_belongs_to_many :evaluates
  has_many :buycars, dependent: :destroy
  has_one :hotsale, dependent: :destroy
  has_many :buyparams, dependent: :destroy
end
