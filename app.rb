require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'yaml'
require 'bcrypt'

require_relative 'lib/authentication'
require_relative 'lib/register'
require_relative 'lib/helpers'

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
    redirect '/protected'
  else
    flash[:notice] = 'wrong email or password'
    redirect '/login'
  end
end

get '/logout' do
  session[:user] = nil
  flash[:notice] = 'You have been signed out.'
  redirect '/'
end

get '/register' do
  erb :register
end

post '/register' do
  if params[:email].blank? || params[:password].blank?
    flash[:notice] = 'invalid email or password, please input again!'
    redirect '/register'
  else
    email = params[:email].downcase
    password = params[:password]
    user = User.create(name: params[:name], email: email, password: password)
    session[:user] = user
    redirect '/login'
  end
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
  author_id = session[:user].user.id
  tweet_body = params[:tweet][:body]
  set_new_tweet(author_id, tweet_body).to_json
  redirect(:tweets)
end

# Lists user's followed tweets.
  # Get timeline pieces
get '/tweets' do
  authenticate!
  user = User.find(session[:user].user.id)
  puts Follow.joins('INNER JOIN tweets ON tweets.author_id=followee_id').where(follower_id: user.id)
  # erb :tweets
end
