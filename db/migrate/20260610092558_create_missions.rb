class CreateMissions < ActiveRecord::Migration[8.1]
  def change
    enable_extension 'pgcrypto'
    create_table :missions do |t|
      t.string :name
      t.references :legal_entity, null: false, foreign_key: true
      t.uuid :uuid, default: "gen_random_uuid()"
      t.string :sso_uuid
      t.timestamps
    end

    create_table :mission_users do |t|
      t.references :mission, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :role
      t.timestamps
    end
  end
end
