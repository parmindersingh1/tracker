class Device < ActiveRecord::Base
  belongs_to :vehicle
  validates :imei_no, :uniqueness => true
  # before_create :set_enabled 
  
  def set_enabled
    self.is_enabled = 0 
  end
end
