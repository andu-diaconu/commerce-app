class CreateElectronics < ActiveRecord::Migration[7.0]
  def change
    create_table :electronics do |t|
      t.string :processor
      t.float :processor_frequency
      t.string :video_card
      t.float :screen_size
      t.string :os
      t.string :battery
      t.float :weight
      t.string :memory_type
      t.integer :memory
      t.float :refresh_rate
      t.string :web_camera
      t.string :audio
      t.integer :category
      t.string :production_year
      t.integer :product_id
      t.references :electronic_function, foreign_key: true
      t.references :electronic_sensor, foreign_key: true

      t.timestamps
    end
  end
end
