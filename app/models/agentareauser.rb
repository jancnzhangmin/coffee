class Agentareauser < ApplicationRecord
  belongs_to :agentareas
  belongs_to :users
end
