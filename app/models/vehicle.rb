class Vehicle < ActiveRecord::Base
  has_one :device
  has_many :routes
end
