class Location < ActiveRecord::Base
  attr_accessor :verified
  attr_accessible :city, :finish, :name, :start, :state, :street, :street_2, :zip, :user, :route  

  belongs_to :user
  belongs_to :route
end
