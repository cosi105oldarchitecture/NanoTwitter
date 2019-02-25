require 'minitest/autorun'
require 'rack/test'
require 'faker'
require_relative '../app'
require_relative '../models/user'

user = User.create(name: 'Adam', email: 'Pito@brandeis.edu', password: 'thebestgroup')

puts user.name
