class AddRoomReferenceToMessage < ActiveRecord::Migration[7.0]
  def up
    remove_reference :messages, :sender, foreign_key: { to_table: :users }
    remove_reference :messages, :receiver, foreign_key: { to_table: :users }
    add_reference :messages, :user, foreign_key: true
    add_reference :messages, :room, foreign_key: true
  end

  def down
    add_column :messages, :sender_id, foreign_key: { to_table: :users }
    add_column :messages, :receiver_id, foreign_key: { to_table: :users }
    remove_reference :messages, :room, foreign_key: true
    remove_reference :messages, :user, foreign_key: true
  end
end
