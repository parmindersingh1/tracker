class Route < ActiveRecord::Base
  belongs_to :vehicle
  has_many :stops
  validates :name, :start_time, :presence => true
end
