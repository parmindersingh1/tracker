class Track < ActiveRecord::Base
  belongs_to :vehicle
  belongs_to :route
  
  attr_accessor :userName
end
