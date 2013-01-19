class SetDefaultForLocations < ActiveRecord::Migration
  def up
    change_column :locations, :start, :boolean, :default => false
    change_column :locations, :finish, :boolean, :default => false
  end

  def down
  end
end
