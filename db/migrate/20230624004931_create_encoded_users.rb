class CreateEncodedUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :encoded_users do |t|
      t.text :value

      t.timestamps
    end
  end
end
