class CreateHomeaways < ActiveRecord::Migration[5.0]
  def change
    create_table :homeaways do |t|
      t.string :info

      t.timestamps
    end
  end
end
