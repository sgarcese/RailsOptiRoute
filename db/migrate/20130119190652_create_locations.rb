class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :user_id
      t.integer :route_id
      t.string :name
      t.string :street
      t.string :street_2
      t.string :city
      t.string :state
      t.string :zip
      t.integer :latitude
      t.integer :longitude
      t.boolean :start
      t.boolean :finish

      t.timestamps
    end

    add_index :locations, :user_id
    add_index :locations, :route_id
  end
end
