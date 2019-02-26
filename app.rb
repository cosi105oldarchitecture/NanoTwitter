require 'sinatra'
require 'sinatra/activerecord'
require_relative './models/user'

get '/' do
  'Hello world!'
end
