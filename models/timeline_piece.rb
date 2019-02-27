# Represents the db's Timeline_piece table
class TimelinePiece < ActiveRecord::Base
  belongs_to :user
  belongs_to :tweet
end
