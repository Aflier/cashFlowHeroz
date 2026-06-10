class CreateLegalEntities < ActiveRecord::Migration[8.1]
  def change
    enable_extension 'pgcrypto'
    create_table :legal_entities do |t|
      t.string :name
      t.string :sso_uuid
      t.uuid :uuid, default: "gen_random_uuid()"

      t.timestamps
    end

    create_table :entity_users do |t|
      t.references :legal_entity, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :role
      t.timestamps
    end
  end
end
