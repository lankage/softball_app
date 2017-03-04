class CreateUserAttendences < ActiveRecord::Migration[5.0]
  def change
    create_table :user_attendences do |t|
      t.integer :user_id
      t.integer :game_id
      t.string :attendance_type

      t.timestamps
    end
  end
end
