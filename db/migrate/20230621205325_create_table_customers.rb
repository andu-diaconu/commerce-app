class CreateTableCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.integer :user_id
      t.integer :product_id
      t.boolean :done, default: "false"

      t.timestamps
    end
  end
end
