class CreateDiscount < ActiveRecord::Migration[7.0]
  def change
    create_table :discounts do |t|
      t.string :code
      t.decimal :value
      t.integer :brand_id

      t.timestamps
    end
  end
end
