class User < ApplicationRecord
  acts_as_mappable
  has_many :agentareausers
  has_many :agentareas, through: :agentareausers
  has_many :childrens, class_name: "User", foreign_key: "up_id"
  belongs_to :parent, class_name: "User", foreign_key: "up_id", optional: true
  has_many :receiveaddrs, dependent: :destroy

  has_many :orders
  has_many :evaluates, dependent: :destroy
  has_many :buycars, dependent: :destroy
  has_many :contracts
  has_many :shopusers
  has_many :examines, dependent: :destroy
  has_many :incomes, dependent: :destroy
  has_many :withdrawals, dependent: :destroy

  after_create :create_uuid

  private
  def create_uuid
    if self.token.to_s.size == 0
      self.token = UUIDTools::UUID.timestamp_create.to_s.tr('-','')
      self.save
    end
  end
end
