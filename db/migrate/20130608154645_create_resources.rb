class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :type
      t.text :description

      t.timestamps
    end
    add_index :resources, :type
  end
end
