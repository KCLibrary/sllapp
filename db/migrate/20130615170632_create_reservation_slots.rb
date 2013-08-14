class CreateReservationSlots < ActiveRecord::Migration
  def change
    create_table :reservation_slots do |t|
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.references :reservation
      t.references :resource

      t.timestamps
    end
    add_index :reservation_slots, :reservation_id
    add_index :reservation_slots, :resource_id
  end
end
