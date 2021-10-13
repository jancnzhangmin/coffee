class CreateTeamorderids < ActiveRecord::Migration[6.0]
  def change
    create_table :teamorderids do |t|
      t.bigint :user_id
      t.bigint :order_id

      t.timestamps
    end
  end
end
