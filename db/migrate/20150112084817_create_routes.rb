class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.references :vehicle, index: true

      t.timestamps
    end
  end
end
