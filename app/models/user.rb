class User < ApplicationRecord
  has_and_belongs_to_many :shops
  has_many :agentareausers
  has_many :agentareas, through: :agentareausers
  has_many :childrens, class_name: "User", foreign_key: "up_id"
  belongs_to :parent, class_name: "User", foreign_key: "up_id", optional: true
  has_many :receiveaddrs, dependent: :destroy
  has_many :posters, dependent: :destroy
  has_many :orders
  has_many :evaluates, dependent: :destroy
end
