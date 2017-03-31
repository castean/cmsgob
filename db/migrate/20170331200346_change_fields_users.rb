class ChangeFieldsUsers < ActiveRecord::Migration
  def change
    remove_column :users, :rol
    remove_column :users, :login
    add_column :users, :username, :string
    add_column :users, :role, :string
  end
end
