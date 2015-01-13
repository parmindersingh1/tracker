class Vehicle < ActiveRecord::Base
  has_one :device
  has_many :routes
  validates :registration_no, :uniqueness => true
  validates :vehicle_type, :presence => true
end
