class AddHiddenToBrands < ActiveRecord::Migration[7.0]
  def change
    add_column :brands, :hidden, :boolean, default: false
  end
end
