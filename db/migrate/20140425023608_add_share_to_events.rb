class AddShareToEvents < ActiveRecord::Migration
  def up
  	add_column :events, :share, :boolean, :default => true
  end
  def down
  	remove_column :events, :share
  end
end
