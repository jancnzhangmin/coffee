class RenameContractForContractdetail < ActiveRecord::Migration[6.0]
  def change
    rename_column :contractdetails, :contract, :contractimg
  end
end
