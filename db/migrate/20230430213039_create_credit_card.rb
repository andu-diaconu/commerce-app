class CreateCreditCard < ActiveRecord::Migration[7.0]
  def change
    create_table :credit_cards do |t|
      t.string :card
      t.string :number
      t.string :month
      t.string :year
      t.string :cvv
      t.string :owner
      t.integer :user_id

      t.timestamps
    end
  end
end
