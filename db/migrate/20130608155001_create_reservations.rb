class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.references :temp_user
      t.references :resource
      t.datetime :start
      t.datetime :end
      t.string :description

      t.timestamps
    end
    add_index :reservations, :temp_user_id
    add_index :reservations, :resource_id
  end
end
