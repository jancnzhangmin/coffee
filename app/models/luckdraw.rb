class Luckdraw < ApplicationRecord
  has_many :luckdrawdetails, dependent: :destroy
end
