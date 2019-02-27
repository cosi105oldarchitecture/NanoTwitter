# Represents the db's Mention table
class Mention < ActiveRecord::Base
  belongs_to :user
  belongs_to :tweet
end
