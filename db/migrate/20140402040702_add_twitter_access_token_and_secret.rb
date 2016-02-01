class AddTwitterAccessTokenAndSecret < ActiveRecord::Migration
  def up
  	add_column :users, :twitter_access_token, :text
  	add_column :users, :twitter_access_token_secret, :text
  end
  def down
  	remove_column :users, :twitter_access_token
  	remove_column :users, :twitter_access_token_secret
  end
end
