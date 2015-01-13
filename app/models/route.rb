class Route < ActiveRecord::Base
  belongs_to :vehicle
  has_many :stops
end
