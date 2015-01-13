class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :registration_no
      t.integer :capacity
      t.string :vehicle_type

      t.timestamps
    end
  end
end
