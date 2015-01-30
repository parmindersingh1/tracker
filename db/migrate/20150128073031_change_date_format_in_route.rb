class ChangeDateFormatInRoute < ActiveRecord::Migration
 def up
    change_column :routes, :start_time, :time
    change_column :routes, :end_time, :time
  end

  def down
    change_column :routes, :start_time, :datetime
    change_column :routes, :end_time, :datetime
  end
end
