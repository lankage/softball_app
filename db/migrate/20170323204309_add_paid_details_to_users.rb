class AddPaidDetailsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :hat_fee_paid, :bool
    add_column :users, :shirt_fee_paid, :bool
    add_column :users, :shorts_fee_paid, :bool
    add_column :users, :buying_shirt, :bool
    add_column :users, :buying_hat, :bool
    add_column :users, :buying_shorts, :bool
  end
end
