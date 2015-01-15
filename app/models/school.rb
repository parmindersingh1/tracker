class School < ActiveRecord::Base
  has_many :vehicles
  has_many :users
  validates :name, :phone_no, :presence => true 
end
