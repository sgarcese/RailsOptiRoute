class AddAddressStringToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :address_string, :string
  end
end
