class CreateJoinTableEvaluateProduct < ActiveRecord::Migration[6.0]
  def change
    create_join_table :evaluates, :products do |t|
      # t.index [:evaluate_id, :product_id]
      # t.index [:product_id, :evaluate_id]
    end
  end
end
