class Route < ActiveRecord::Base
  attr_accessible :optimized, :user

  belongs_to :user
  has_many :locations

  accepts_nested_attributes_for :locations
end
