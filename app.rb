require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'yaml'
require 'bcrypt'

require_relative 'lib/authentication'
require_relative 'lib/register'

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
  followee = User.find_by(email: params[:email])
  Follow.create(follower_id: user.id, followee_id: followee.id)
  flash[:notice] = 'succeed'
  redirect '/users'
end

get '/users/unfollowing' do
  authenticate!
  user = session[:user]
  @users = User.all
  @users.delete(user)
  following = Follow.where(follower_id: user.id)
  for f in following do
    u = User.find_by(id: f.followee_id)
    @users.delete(u)
  end
  erb :unfollowing
end


# add this to routes if this need to be protected.
get '/protected' do
  authenticate!
  'Welcome back!'
end
