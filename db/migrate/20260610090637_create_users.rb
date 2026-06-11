class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.string :provider
      t.string :uid
      t.boolean :in_mission_control
      t.text :filters_store

      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end
