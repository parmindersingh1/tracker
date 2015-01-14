class Vehicle < ActiveRecord::Base
  resourcify
  belongs_to :school
  has_one :device
  has_many :routes
  validates :registration_no, :uniqueness => true
  validates :vehicle_type,:registration_no, :presence => true
end
