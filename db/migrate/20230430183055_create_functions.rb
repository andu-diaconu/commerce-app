class CreateFunctions < ActiveRecord::Migration[7.0]
  def change
    create_table :functions do |t|
      t.string :name, null: false, default: ""
      t.text :description

      t.timestamps
    end
  end
end
