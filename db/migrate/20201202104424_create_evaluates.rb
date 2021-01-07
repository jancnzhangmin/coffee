class CreateEvaluates < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluates do |t|
      t.bigint :product_id
      t.bigint :user_id
      t.float :speed
      t.float :quality
      t.text :summary
      t.integer :status
      t.index :product_id
      t.index :user_id

      t.timestamps
    end
  end
end
