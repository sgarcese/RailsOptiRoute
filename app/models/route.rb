class Route < ActiveRecord::Base
  attr_accessible :optimized, :user, :locations_attributes, :name

  belongs_to :user
  has_many :locations

  validates_presence_of :name
  validate :has_locations

  accepts_nested_attributes_for :locations

  private
  def has_locations
    return true if locations.length > 1
    self.errors.add(:base, "routs require 2 locations or more")
  end
end
