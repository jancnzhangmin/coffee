class AddUseridToAgentareauser < ActiveRecord::Migration[6.0]
  def change
    add_column :agentareausers, :user_id, :bigint
  end
end
