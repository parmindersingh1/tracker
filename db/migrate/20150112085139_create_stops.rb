class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.string :name
      t.decimal :latitude
      t.decimal :longitude
      t.string :timeperiod
      t.integer :sequence
      t.references :route, index: true

      t.timestamps
    end
  end
end
