class AddBusinetypeToAgentlevel < ActiveRecord::Migration[6.0]
  def change
    add_column :agentlevels, :businetype, :string
  end
end
