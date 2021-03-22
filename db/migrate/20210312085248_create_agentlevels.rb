class CreateAgentlevels < ActiveRecord::Migration[6.0]
  def change
    create_table :agentlevels do |t|
      t.string :name
      t.float :profitratio
      t.bigint :corder
      t.integer :frontdisplay

      t.timestamps
    end
  end
end
