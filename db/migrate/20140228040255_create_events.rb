class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.integer :timeline_id, :limit => 8
      t.datetime :date
      t.text :description
      t.string :tweet

      t.timestamps
    end
  end

  def down
    drop_table :events
  end
end
