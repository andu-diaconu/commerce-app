class CreateBrands < ActiveRecord::Migration[7.0]
  def change
    create_table :brands do |t|
      t.string :name, null: false, default: ""
      t.string :website
      t.string :email
      t.string :logo

      t.timestamps
    end
  end
end
