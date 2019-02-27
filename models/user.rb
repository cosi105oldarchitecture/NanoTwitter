# Represents the db's User table
class User < ActiveRecord::Base
  has_many :follows_from_me, class_name: 'Follow', foreign_key: :follower_id
  has_many :followees, through: :follows_from_me

  # Followers are people who follow this user
  has_many :follows_to_me, class_name: 'Follow', foreign_key: :followee_id
  has_many :followers, through: :follows_to_me

  has_many :tweets
  has_many :tweet_tags, through: :tweets
  has_many :mentions, through: :tweet_tags
  has_many :timeline_pieces
  has_many :mentions

  # A convenient method for following a user
  def follow(followee)
    Follow.create(follower_id: id, followee_id: followee.id)
  end
end
