class Route < ActiveRecord::Base
  attr_accessible :optimized, :user, :locations_attributes

  belongs_to :user
  has_many :locations

  validate :has_locations

  accepts_nested_attributes_for :locations

  private
  def has_locations
    return true if locations.to_a.count > 1
    self.errors.add(:base, "routs require 2 locations or more")
  end
end
