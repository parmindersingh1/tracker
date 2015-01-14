class Route < ActiveRecord::Base
  belongs_to :vehicle
  has_many :stops
  validates :name, :start_time, :presence => true
  validate :validate_timings  
  
   def validate_timings
    if (start_time >= end_time) 
      errors[:base] << "Start Time must be less than End Time"
    end
  end
end
