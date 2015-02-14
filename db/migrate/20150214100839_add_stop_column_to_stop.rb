class AddStopColumnToStop < ActiveRecord::Migration
  def change
    add_column :stops, :is_stop, :boolean
  end
end
