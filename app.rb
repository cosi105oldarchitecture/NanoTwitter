require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'byebug'
require 'yaml'
require 'bcrypt'
require 'json'

require_relative 'lib/authentication'
require_relative 'lib/user'

ENV['APP_ROOT'] = settings.root

require_relative './models/user'

# To be used instead of a require_relative for every model.
# Uncomment the below line once all models are working.
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
  if user = User.authenticate(params)
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

	file = File.read('file.json')
    if file.empty?
	    data = Hash.new()
    else
    	data = JSON.parse(file)
	end

	if params[:username].blank? || params[:password].blank?
		flash[:notice] = 'invalid username or password, please input again!'
		redirect '/register'
	else 
		username = params[:username]
		password = params[:password]
		password_code = BCrypt::Password.create(password)
		if data.nil?
			data = Hash.new
		end
		data[username] = password_code
		File.open("file.json","w") do |f|
	      f.write(data.to_json)
	    end

		user = User.new(username)
		session[:user] = user
		redirect '/login'
	end
end

# add this to routes if this need to be protected.
get '/protected' do
  authenticate!
  "Welcome back!"
end




