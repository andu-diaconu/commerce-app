class CreateEntertainmentFunctions < ActiveRecord::Migration[7.0]
  def change
    create_table :entertainment_functions do |t|
      t.integer :entertainment_id
      t.integer :function_id

      t.timestamps
    end
  end
end
