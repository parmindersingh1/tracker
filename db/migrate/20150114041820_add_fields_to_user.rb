class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_reference :users, :school, index: true
  end
end
