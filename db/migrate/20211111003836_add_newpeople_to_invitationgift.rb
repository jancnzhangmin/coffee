class AddNewpeopleToInvitationgift < ActiveRecord::Migration[6.0]
  def change
    add_column :invitationgifts, :newpeople, :integer
    add_column :invitationgifts, :oldpeople, :integer
  end
end
