class RemoveTweetFromEvents < ActiveRecord::Migration
  def up
  	remove_column :events, :tweet
  end
  def down
  	add_column :events, :tweet, :string
  end
end