class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.decimal :latitude,  precision: 10, scale: 7
      t.decimal :longitude,  precision: 10, scale: 7
      t.string :sessionid
      t.integer :speed
      t.integer :direction
      t.decimal :distance,  precision: 10, scale: 1
      t.datetime :gpstime
      t.string :locationmethod
      t.integer :accuracy
      t.string :extrainfo
      t.string :eventtype
      t.references :vehicle, index: true
      t.references :route, index: true

      t.timestamps
    end
  end
end
