class CreateReview < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :product_id
      t.string :title, default: ""
      t.text :message, default: ""
      t.string :user_identifier
      t.string :identifier, null: false, unique: true

      t.timestamps
    end
  end
end
