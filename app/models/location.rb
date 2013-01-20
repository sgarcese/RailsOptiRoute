class Location < ActiveRecord::Base
  attr_accessor :verified
  attr_accessible :finish, :name, :start, :address_string, :user, :latitude, :longitude, :user_id

  belongs_to :user
  belongs_to :route

  validates_presence_of :address_string, :latitude, :longitude, :user
end
