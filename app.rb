require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'yaml'
require 'bcrypt'

# Byebug will be conveniently accessible in dev but throw
# an error if we accidentally deploy with a breakpoint
# require 'pry-byebug' if Sinatra::Base.development?

require_relative 'lib/authentication'
require_relative 'lib/register'
require_relative 'lib/helpers'
require_relative 'lib/seeds'

ENV['APP_ROOT'] = settings.root

Dir["#{ENV['APP_ROOT']}/models/*.rb"].each { |file| require file }

# Expire sessions after ten minutes of inactivity
TEN_MINUTES = 60 * 10
use Rack::Session::Pool, expire_after: TEN_MINUTES
helpers Authentication

get '/' do
  erb :main
end

get '/login' do
  erb :login
end

post '/login' do
  if user = Register.authenticate(params)
    session[:user] = user
    redirect '/users'
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
  erb :register
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

get '/users' do
  authenticate!
  @user = session[:user]
  erb :users
end

get '/users/followers' do
  authenticate!
  @user = session[:user]
  @followers = Follow.where(followee_id: @user.id)
  erb :user_follower
end

get '/users/following' do
  authenticate!
  @user = session[:user]
  @following = Follow.where(follower_id: @user.id)
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
  # @users = User.where.not(id: user.id)
  # following = Follow.where(follower_id: user.id)
  # followees = user.followees.pluck(:id)
  @users = User.all - user.followees
  erb :unfollowing
end

# add this to routes if this need to be protected.
get '/protected' do
  authenticate!
  'Welcome back!'
end

# Page for composing/posting new tweet.
get '/tweets/new' do
  authenticate!
  erb :new_tweet
end

# API endpoint for creating/posting a new tweet.
  # Replace "v1" with global variable
  # Pass session token as parameter
  # Use session token to get author_id
  # Decide whether to continue server-side parsing tweet body to extract mentions & hashtags.
  # Add error handling
  # Check that user is logged in
post '/api/v1/tweets/new' do
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
  # erb :tweets
end

get '/test' do
  erb :test
end

post '/test/reset/all' do
  delete_all
  load './seeds.rb'
end

post '/test/reset/standard?users=100&tweets=100' do
  delete_all
  seed_users(100)
  seed_follows(100)
  seed_tweets(100)

end

# post '/test/user/:userid/tweets?count=n' do

# {u} can be the user id of some user, or the keyword testuser
# n is how many randomly generated tweets are submitted on that users behalf

# end



# get '/test/status' do

# end




