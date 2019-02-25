# Represents the db's User table
class User < ActiveRecord::Base
  has_many :follows
  has_many :followers, through: :follows
  has_many :followees, through: :follows
  has_many :tweets
  has_many :tweet_tags, through: :tweets
  has_many :timeline_pieces
  has_many :mentions
end
