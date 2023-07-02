class AddRatingSumOnProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :rating_sum, :float
  end
end
