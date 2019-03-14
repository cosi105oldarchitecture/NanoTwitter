require 'bcrypt'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'yaml'
<<<<<<< HEAD
=======
require 'bcrypt'
require 'faker'
>>>>>>> yangshang

# Byebug will be conveniently accessible in dev but throw
# an error if we accidentally deploy with a breakpoint
require 'pry-byebug' if Sinatra::Base.development?

require_relative 'lib/authentication'
require_relative 'lib/register'
require_relative 'lib/helpers'
<<<<<<< HEAD
require_relative 'version'
=======
require_relative 'lib/seeds_helper'

>>>>>>> yangshang

ENV['APP_ROOT'] = settings.root
Dir["#{ENV['APP_ROOT']}/models/*.rb"].each { |file| require file }

# Expire sessions after ten minutes of inactivity
TEN_MINUTES = 60 * 10
use Rack::Session::Pool, expire_after: TEN_MINUTES
helpers Authentication

API_PATH = "/api/#{NanoTwitter::VERSION}"

get '/' do
  erb :landing_page, layout: false
end

get '/login' do
  erb :login, layout: false
end

post '/login' do
  if user = Register.authenticate(params)
    session[:user] = user
    redirect '/tweets'
  else
    flash[:notice] = 'wrong handle or password'
    redirect '/login'
  end
end

post '/logout' do
  session[:user] = nil
  flash[:notice] = 'You have been signed out.'
  redirect '/'
end

get '/register' do
  erb :register, layout: false
end

post '/register' do
  if params[:handle].blank? || params[:password].blank?
    flash[:notice] = 'invalid handle or password, please input again!'
    redirect '/register'
  else
    handle = params[:handle].downcase
    password = params[:password]
    user = User.create(name: params[:name], handle: handle, password: password)
    session[:user] = user
    redirect '/login'
  end
end

get '/users/profile' do
  @user = session[:user]
  erb :profile
end

# get '/users' do
#   authenticate!
#   @user = session[:user]
#   erb :users
# end

get '/users/followers' do
  authenticate!
  user = session[:user]
  # user = User.find(1000) #REMOVE
  @followers = user.followers
  erb :user_follower
end

get '/users/following' do
  authenticate!
  user = session[:user]
  # user = User.find(1000) #REMOVE
  @followees = user.followees
  erb :user_following
end

post '/users/following' do
  authenticate!
  user = session[:user]
  followee = User.find_by(name: params[:name])
  Follow.create(follower_id: user.id, followee_id: followee.id)
  flash[:notice] = 'succeed'
  redirect '/users'
end

get '/users/unfollowing' do
  authenticate!
  user = session[:user]
  @users = User.all - user.followees
  erb :unfollowing
end

# add this to routes if this need to be protected.
get '/protected' do
  authenticate!
end

# Page for composing/posting new tweet.
get '/tweets/new' do
  authenticate!
  erb :new_tweet
end

# API endpoint for creating/posting a new tweet.
  # Pass session token as parameter
  # Use session token to get author_id
  # Decide whether to continue server-side parsing tweet body to extract mentions & hashtags.
  # Add error handling
  # Check that user is logged in
post "#{API_PATH}/tweets/new" do
  authenticate!
  author_id = session[:user].id
  tweet_body = params[:tweet][:body]
  puts set_new_tweet(author_id, tweet_body).to_json
  # redirect(:tweets)
end

# Lists user's followed tweets.
  # Get timeline pieces
get '/tweets' do
  authenticate!
  user = User.find(session[:user].id)
  # user = User.find(1000) #REMOVE
  @timeline = user.timeline_tweets
  erb :tweets
end

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


# One page “report”:
# How many users, follows, and tweets are there
# What is the TestUser’s id
get '/test/status' do
  @users_num = User.count,
  @follow_num = Follow.count,
  @tweet_num = Tweet.count,
  @testuser_id = User.find_by(name: 'testuser').id
  erb :report
end




