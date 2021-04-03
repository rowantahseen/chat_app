class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :acess_token
      t.string :name

      t.timestamps
    end
    add_index :applications, :acess_token, unique: true
  end
end
