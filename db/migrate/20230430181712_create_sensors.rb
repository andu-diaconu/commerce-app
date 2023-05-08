class CreateSensors < ActiveRecord::Migration[7.0]
  def change
    create_table :sensors do |t|
      t.string :name, null: false, default: ""
      t.text :description

      t.timestamps
    end
  end
end
