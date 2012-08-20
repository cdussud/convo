class AddSessionTokenToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :session_token, :string, null: false
  end
end
