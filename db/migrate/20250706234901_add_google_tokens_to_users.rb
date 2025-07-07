class AddGoogleTokensToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :token, :text
    add_column :users, :refresh_token, :text
  end
end
