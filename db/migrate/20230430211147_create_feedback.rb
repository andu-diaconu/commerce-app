class CreateFeedback < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.integer :product_id
      t.string :message

      t.timestamps
    end
  end
end
