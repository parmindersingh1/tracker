class School < ActiveRecord::Base
  resourcify
  has_many :vehicles
  has_many :users
end
