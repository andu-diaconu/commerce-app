class CreateShippingAddress < ActiveRecord::Migration[7.0]
  def change
    create_table :shipping_addresses do |t|
      t.string :country
      t.string :district
      t.string :city
      t.string :street
      t.string :bl
      t.string :apartament

      t.timestamps
    end
  end
end
