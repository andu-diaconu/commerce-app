class CreateBillingAddress < ActiveRecord::Migration[7.0]
  def change
    create_table :billing_addresses do |t|
      t.string :country
      t.string :district
      t.string :city
      t.string :street
      t.string :bl
      t.string :apartament
      t.integer :user_id

      t.timestamps
    end
  end
end
