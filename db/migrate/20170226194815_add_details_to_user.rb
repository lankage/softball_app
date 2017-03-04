class AddDetailsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :desired_teammates, :text
    add_column :users, :positions, :text
    add_column :users, :shirt_size, :string
    add_column :users, :gender, :string
    add_column :users, :haspaid, :boolean
    add_column :users, :player_type, :string
  end
end
