class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.date :date
      t.time :time
      t.string :homeaway
      t.text :comments

      t.timestamps
    end
  end
end
