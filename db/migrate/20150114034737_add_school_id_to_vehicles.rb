class AddSchoolIdToVehicles < ActiveRecord::Migration
  def change
    add_reference :vehicles, :school, index: true
  end
end
