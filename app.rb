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
