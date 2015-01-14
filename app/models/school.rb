class School < ActiveRecord::Base
  has_many :vehicles
  has_many :users
end
