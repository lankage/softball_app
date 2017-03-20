class AddShortSizeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :shortsize, :string
  end
end
