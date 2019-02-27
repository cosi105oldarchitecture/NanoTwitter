# Initializes db's Follow table
class CreateFolllowTable < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.integer :follower_id
      t.integer :followee_id
    end
  end
end
