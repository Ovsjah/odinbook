class CreateRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :relations do |t|
      t.bigint :user_id
      t.bigint :pal_id
    end
    add_index :relations, [:user_id, :pal_id], unique: true
  end
end
