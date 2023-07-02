class AddHiddenOnProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :hidden, :boolean, default: false
  end
end
