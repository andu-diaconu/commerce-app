class CreateMessage < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :sender, foreign_key: { to_table: :users }
      t.references :receiver, foreign_key: { to_table: :users }
      t.text :content, null: false

      t.timestamps
    end
  end
end
