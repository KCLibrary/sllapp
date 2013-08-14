class DropTempUser < ActiveRecord::Migration
  def change
    drop_table :temp_users
  end
end
