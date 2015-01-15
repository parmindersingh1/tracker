class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :role, :string
    add_reference :users, :school, index: true
  end
end
