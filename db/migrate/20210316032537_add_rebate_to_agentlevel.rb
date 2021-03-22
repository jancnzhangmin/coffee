class AddRebateToAgentlevel < ActiveRecord::Migration[6.0]
  def change
    add_column :agentlevels, :rebate, :float
    add_column :agentlevels, :isyearend, :integer
  end
end
