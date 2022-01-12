class AddLimitnewpeopleToSinglediscount < ActiveRecord::Migration[6.0]
  def change
    add_column :singlediscounts, :limitnewpeople, :integer
    add_column :singlediscounts, :newpeopletime, :datetime
  end
end
