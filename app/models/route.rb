class Route < ActiveRecord::Base
  belongs_to :vehicle
  has_many :stops
  validates :name, :start_time, :presence => true
  # validate :validate_timings  
  
  # before_save :assign_name unless self.latitude.nil? && self.longitude.nil?
   # def validate_timings
    # if (start_time >= end_time) 
      # errors[:base] << "Start Time must be less than End Time"
    # end
  # end
#   
  # def assign_name(lat, long)
    # if self.name.nil?
      # Geocoder.search(lat, long)
    # end
  # end
end
