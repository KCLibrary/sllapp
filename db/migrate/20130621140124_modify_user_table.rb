class ModifyUserTable < ActiveRecord::Migration
  def change
    
    remove_index :users, :name => "index_users_on_email"
    rename_column :users, :email, :uid
    
    add_column :users, :email, :string
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
    
    
    add_index :users, :uid
    
  end
end
