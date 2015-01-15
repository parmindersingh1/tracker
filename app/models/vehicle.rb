class Vehicle < ActiveRecord::Base
  belongs_to :school
  has_one :device
  has_many :routes
  validates :registration_no, :uniqueness => true
  validates :vehicle_type,:registration_no, :school_id, :presence => true
end
