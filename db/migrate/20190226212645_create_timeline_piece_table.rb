# Initializes db's Timeline Piece table
class CreateTimelinePieceTable < ActiveRecord::Migration[5.2]
  def change
    create_table :timeline_pieces do |t|
      t.integer :timeline_owner_id
      t.integer :tweet_id
    end
  end
end
