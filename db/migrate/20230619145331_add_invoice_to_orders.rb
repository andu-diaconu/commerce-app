class AddInvoiceToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :invoice, :string, default: ""
  end
end
