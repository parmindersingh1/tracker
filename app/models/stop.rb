class Stop < ActiveRecord::Base
  belongs_to :route
  validates :latitude,:longitude, :presence => true  
  # before_save :assign_name 
  reverse_geocoded_by :latitude, :longitude,  :address => :name
  after_validation :reverse_geocode
  
  
  def check_distance  b
    a = [self.latitude,self.longitude]
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlon_rad = (b[1]-a[1]) * rad_per_deg  # Delta, converted to rad
    dlat_rad = (b[0]-a[0]) * rad_per_deg

    lat1_rad, lon1_rad = a.map! {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = b.map! {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c # Delta in Kilometers
  end
  
  # def assign_name
    # unless self.latitude.nil? && self.longitude.nil?
    # self.name = Geocoder.search("#{self.latitude}, #{self.longitude}") unless self.name.nil?
    # puts "(((((((((((((((((((#{Geocoder.search("#{self.latitude}, #{self.longitude}")})))))))))))))))))))"
    # end
  # end

# puts distance [46.3625, 15.114444],[46.055556, 14.508333]
end
