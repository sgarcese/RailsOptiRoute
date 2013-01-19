class ConvertAddressFieldsToAddressStringForLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :street
    remove_column :locations, :street_2
    remove_column :locations, :city
    remove_column :locations, :state
    remove_column :locations, :zip
  end
end
