class Agentarea < ApplicationRecord
  has_many :agentareausers
  has_many :users, through: :agentareausers
end
