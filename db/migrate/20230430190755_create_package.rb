class CreatePackage < ActiveRecord::Migration[7.0]
  def change
    create_table :packages do |t|
      t.string :name, null: false, default: ""
      t.string :description

      t.timestamps
    end
  end
end
