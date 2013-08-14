class CreateTempUsers < ActiveRecord::Migration
  def change
    create_table :temp_users do |t|
      t.string :name
      t.string :card_number

      t.timestamps
    end
    add_index :temp_users, :card_number
  end
end
