class RenameReservationColumns < ActiveRecord::Migration
  def change
    rename_column :reservations, :end, :end_datetime
    rename_column :reservations, :start, :start_datetime
  end
end
