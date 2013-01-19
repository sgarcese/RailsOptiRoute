class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.integer :user_id
      t.boolean :optimized

      t.timestamps
    end
  end
end
