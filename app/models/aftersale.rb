class Aftersale < ApplicationRecord
  belongs_to :order
  has_many :aftersaleimgs, dependent: :destroy
end
