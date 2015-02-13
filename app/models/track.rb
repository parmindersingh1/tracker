class Track < ActiveRecord::Base
  belongs_to :vehicle
  belongs_to :route  
 attr_accessor :device, :route_name
 
 # def self.to_hash
  # all.to_a.map(&:serializable_hash)
# end
#   


end
