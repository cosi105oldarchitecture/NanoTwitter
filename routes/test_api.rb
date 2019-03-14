require_relative '../lib/seeds_helper'
require 'faker'

post '/test/reset/all' do
  delete_all
  seed_users(nil)
  seed_follows(nil)
  seed_tweets(nil)
  seed_testuser
end

post '/test/reset' do
  users = params[:users]
  tweets = params[:tweets]
  delete_all
  seed_users(users.to_i)
  seed_follows(users.to_i)
  seed_tweets(tweets.to_i)


  seed_testuser
end

post '/test/user/:userid/tweets' do
  userid = params[:userid]
  n = params[:count].to_i
  (0..n-1).each do |i|
    t = Faker::Twitter.status
    Tweet.create(author_id: userid.to_i, body: t["text"], created_on: t["created_at"])
  end
end


# One page "report":
# How many users, follows, and tweets are there
# What is the TestUser's id
get '/test/status' do
  @users_num = User.count
  @follow_num = Follow.count
  @tweet_num = Tweet.count
  @testuser_id = User.find_by(name: 'testuser').id
  erb :report
end
