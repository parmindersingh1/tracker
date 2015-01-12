class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :mobile_no
      t.string :imei_no
      t.references :vehicle, index: true
      t.boolean :is_enabled

      t.timestamps
    end
  end
end
