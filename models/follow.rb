# Represents the db's Follow table
class Follow < ActiveRecord::Base
  belongs_to :follower, class: 'User'
  belongs_to :followee, class: 'User'
end
