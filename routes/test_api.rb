require_relative '../lib/seeds_helper'

post '/test/reset/all' do
  delete_all
  Rake::Task['db:dump:seed'].execute
  status 200
end

post '/test/reset' do
  users = params[:users]
  tweets = params[:tweets]
  delete_all

  seed_users(users.to_i)
  seed_follows(users.to_i)
  seed_tweets(tweets.to_i)
  seed_testuser
  status 200
end

post '/test/user/:userid/tweets' do
  userid = params[:userid]
  n = params[:count].to_i
  (0..n-1).each do |i|
    t = Faker::Twitter.status
    Tweet.create(author_id: userid.to_i, body: t["text"], created_on: t["created_at"])
  end
  status 200
end

# One page "report":
# How many users, follows, and tweets are there
# What is the TestUser's id
get '/test/status' do
  load_status
  erb :report
end
