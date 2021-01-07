class CreateEvaluateimgs < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluateimgs do |t|
      t.bigint :evaluate_id
      t.string :evaluateimg
      t.index :evaluate_id

      t.timestamps
    end
  end
end
