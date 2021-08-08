class Orderdetail < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_many :orderdetailparams, dependent: :destroy
end
