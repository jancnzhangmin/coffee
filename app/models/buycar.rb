class Buycar < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many :buycarparams, dependent: :destroy
end
