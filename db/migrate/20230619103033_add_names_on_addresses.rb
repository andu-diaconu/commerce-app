class AddNamesOnAddresses < ActiveRecord::Migration[7.0]
  def change
    add_column :billing_addresses, :first_name, :string, default: ""
    add_column :billing_addresses, :last_name, :string, default: ""
    add_column :billing_addresses, :email, :string, default: ""
    add_column :billing_addresses, :phone, :string, default: ""
    add_column :shipping_addresses, :first_name, :string, default: ""
    add_column :shipping_addresses, :last_name, :string, default: ""
    add_column :shipping_addresses, :email, :string, default: ""
    add_column :shipping_addresses, :phone, :string, default: ""
  end
end
