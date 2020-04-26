class CreateFriendRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :friend_requests do |t|
      t.bigint :sender_id
      t.bigint :receiver_id
      t.boolean :accepted, default: false
    end
    add_index :friend_requests, [:sender_id, :receiver_id], unique: true
  end
end
