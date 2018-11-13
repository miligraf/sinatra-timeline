class RemoveTweetFromEvents < ActiveRecord::Migration[5.2]
  def up
  	remove_column :events, :tweet
  end
  def down
  	add_column :events, :tweet, :string
  end
end
