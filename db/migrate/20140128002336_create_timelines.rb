class CreateTimelines < ActiveRecord::Migration
  def up
    create_table :timelines do |t|
      t.integer :user_id, :limit => 8
      t.string :title
      t.text :description

      t.timestamps
    end
  end

  def down
    drop_table :timelines
  end
end
