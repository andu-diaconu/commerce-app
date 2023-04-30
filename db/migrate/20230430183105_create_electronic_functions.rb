class CreateElectronicFunctions < ActiveRecord::Migration[7.0]
  def change
    create_table :electronic_functions do |t|
      t.integer :electronic_id
      t.integer :function_id

      t.timestamps
    end
  end
end
