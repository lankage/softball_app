class CreateBeers < ActiveRecord::Migration[5.0]
  def change
    create_table :beers do |t|
      t.integer :user_id
      t.integer :count

      t.timestamps
    end
  end
end
