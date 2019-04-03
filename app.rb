require 'bundler'
Bundler.require
require 'open-uri'
require 'redis'
require 'json'
require_relative './db/redis_seeder'
require_relative 'version'
Dir.glob('rake/*.rake').each { |r| load r }

if Sinatra::Base.production?
  configure do
    uri = URI.parse(ENV['REDISTOGO_URL'])
    REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
    REDIS.flushall # Clear the cache
    `cat ./db/timeline_seed_protocol.txt | redis-cli --pipe` # Seed cache
  end
else
  require 'dotenv'
  Dotenv.load 'config/local_vars.env'
  require 'pry-byebug'
  REDIS = Redis.new
  # write_redis_seed_protocol
end

ENV['APP_ROOT'] = settings.root
API_PATH = "/api/#{NanoTwitter::VERSION}"
%w[models lib routes].each do |s|
  Dir["#{ENV['APP_ROOT']}/#{s}/*.rb"].each { |file| require file }
end

# Expire sessions after ten minutes of inactivity
TEN_MINUTES = 60 * 10
use Rack::Session::Pool, expire_after: TEN_MINUTES
helpers Authentication

get '/' do
  erb :landing_page, layout: false
end

get '/login' do
  erb :login, layout: false
end

post '/login' do
  if login(params)
    # If cache miss, load timeline into cache
    user = session[:user]
    cache_timeline unless REDIS.exists("#{user.handle}:timeline_size")
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
  user = register_user(params)
  if user.nil?
    flash[:notice] = 'invalid handle or password, please input again!'
    redirect '/register'
  else
    session[:user] = user
    redirect '/login'
  end
end

get '/users/profile' do
  authenticate_or_home!
  @user = session[:user]
  erb :profile
end

get '/users/followers' do
  authenticate_or_home!
  user = session[:user]
  @followers = user.followers
  erb :user_follower
end

get '/users/following' do
  authenticate_or_home!
  user = session[:user]
  @followees = user.follows_from_me
  erb :user_following
end

post '/users/following' do
  authenticate_or_home!
  user = session[:user]
  followee = User.find_by(name: params[:name])
  Follow.create(follower_id: user.id, followee_id: followee.id)
  flash[:notice] = 'succeed'
  redirect '/users'
end

get '/users/unfollowing' do
  authenticate_or_home!
  user = session[:user]
  @users = User.all - user.followees
  erb :unfollowing
end

# add this to routes if this need to be protected.
get '/protected' do
  authenticate_or_home!
end

# Page for composing/posting new tweet.
get '/tweets/new' do
  authenticate_or_home!
  @path = "#{API_PATH}/tweets/new"
  erb :new_tweet
end

# Lists user's followed tweets.
get '/tweets' do
  authenticate_or_home!

  @pagenum = 0
  if !params[:pagenum].nil?
    @pagenum = params[:pagenum].to_i
  end
  
  user = User.find(session[:user].id)
  @timeline = REDIS.get("#{user.id}:timeline_html")
  # @total = 0
  # @begin = 0
  # if !@timeline.nil?
  #   @timeline = @timeline.split("</li>")
  #   @timeline = @timeline[@begin, 10]
  #   @total = @timeline.count
  #   @begin = @pagenum * 10
  # else
  #   @timeline = [""]
  # end

  erb :tweets
end

