class Stop < ActiveRecord::Base
  resourcify
  belongs_to :route
  validates :latitude,:longitude, :presence => true 
end
