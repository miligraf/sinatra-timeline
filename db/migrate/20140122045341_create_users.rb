class CreateUsers < ActiveRecord::Migration
	def up
    create_table :users do |t|
      t.integer :twitter_uid, :limit => 8
      t.string :twitter_nickname

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end