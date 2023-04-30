class CreateEntertainmentPackages < ActiveRecord::Migration[7.0]
  def change
    create_table :entertainment_packages do |t|
      t.integer :entertainment_id
      t.integer :package_id

      t.timestamps
    end
  end
end
