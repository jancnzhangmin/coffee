class Evaluate < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :products
  has_many :evaluateimgs, dependent: :destroy
end
