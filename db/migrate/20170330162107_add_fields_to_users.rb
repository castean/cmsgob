class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login, :string
    add_column :users, :rol, :string
    add_column :users, :fullname, :string
  end
end
