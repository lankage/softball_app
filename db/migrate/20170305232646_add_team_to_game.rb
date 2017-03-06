class AddTeamToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :forteam, :string
  end
end
