class Buyparam < ApplicationRecord
  belongs_to :product
  has_many :buyparamvalues, dependent: :destroy

  after_create :create_corder

  private
  def create_corder
    if self.corder.to_i == 0
      self.update(corder: self.id)
    end
  end
end
