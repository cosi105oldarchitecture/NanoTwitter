require 'sinatra'
require 'sinatra/activerecord'
ENV['APP_ROOT'] = settings.root

require_relative './models/user'

# To be used instead of a require_relative for every model.
# Uncomment the below line once all models are working.
Dir["#{ENV['APP_ROOT']}/models/*.rb"].each { |file| require file }

get '/' do
  'Hello world!'
end
