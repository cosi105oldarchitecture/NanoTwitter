require_relative './test_helper'
require_relative '../models/user'

user = User.create(name: 'Ari', email: '123@test.com', password: 'also123')

puts user.name