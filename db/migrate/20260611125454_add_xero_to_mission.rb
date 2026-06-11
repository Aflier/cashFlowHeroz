class AddXeroToMission < ActiveRecord::Migration[8.1]
  def change
    add_column :missions, :tenant_id, :string
    add_column :missions, :access_token, :string
    add_column :missions, :refresh_token, :string
    add_column :missions, :expires_at, :datetime
  end
end
