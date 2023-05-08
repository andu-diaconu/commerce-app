class CreateElectronicsSensors < ActiveRecord::Migration[7.0]
  def change
    create_table :electronic_sensors do |t|
      t.integer :electronic_id
      t.integer :sensor_id

      t.timestamps
    end
  end
end
