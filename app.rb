require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'yaml'
require 'bcrypt'

require_relative 'lib/authentication'
require_relative 'lib/register'

ENV['APP_ROOT'] = settings.root

Dir["#{ENV['APP_ROOT']}/models/*.rb"].each { |file| require file }

TEN_MINUTES   = 60 * 10
use Rack::Session::Pool, expire_after: TEN_MINUTES # Expire sessions after ten minutes of inactivity
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
  	puts "wrong"
    flash[:notice] = 'wrong username or password'
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
	if params[:username].blank? || params[:password].blank?
		flash[:notice] = 'invalid username or password, please input again!'
		redirect '/register'
	else
		username = params[:username].downcase
		password = params[:password]
		user = User.create(username: username, password: password)
		session[:user] = user
        byebug
		redirect '/login'
	end
end

# add this to routes if this need to be protected.
get '/protected' do
  authenticate!
  "Welcome back!"
end
