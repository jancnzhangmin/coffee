class Showparam < ApplicationRecord
  belongs_to :product
  after_create :create_corder

  private
  def create_corder
    if self.corder.to_s.size == 0
      self.corder = self.id
      self.save
    end
  end
end
