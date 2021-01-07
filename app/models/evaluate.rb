class Evaluate < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many :evaluateimgs, dependent: :destroy
end
