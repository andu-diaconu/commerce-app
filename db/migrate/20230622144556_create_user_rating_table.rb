class CreateUserRatingTable < ActiveRecord::Migration[7.0]
  def change
    create_table :user_ratings do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :value

      t.timestamps
    end
  end
end
