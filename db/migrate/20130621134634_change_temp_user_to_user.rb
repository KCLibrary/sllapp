class ChangeTempUserToUser < ActiveRecord::Migration
  def change
    rename_column :reservations, :temp_user_id, :user_id
    remove_index :reservations, :name => "index_reservations_on_temp_user_id"
    add_index :reservations, :user_id
  end
end
