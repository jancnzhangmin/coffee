class AddExpiredayToInvitationgift < ActiveRecord::Migration[6.0]
  def change
    add_column :invitationgifts, :expireday, :integer
  end
end
