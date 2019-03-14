# This file is a DRY way to set all of the requirements
# that our tests will need, as well as a before statement
# that purges the database and creates fixtures before every test

ENV['APP_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'faker'
require_relative '../app'

# Define file path pattern for identifying test files:
test_pattern = 'test/*/*_test.rb'

def app
  Sinatra::Application
end

describe 'NanoTwitter' do
  before do
    ActiveRecord::Base.subclasses.each(&:destroy_all)
    @ari = User.create(name: 'Ari', handle: '@ari', password: 'ari123')
    @brad = User.create(name: 'Brad', handle: '@brad', password: 'brad123')
    @yang = User.create(name: 'Yang', handle: '@yang', password: 'yang123')
    @pito = User.create(name: 'Pito', handle: '@pito', password: 'pito123')
  end

  Dir["#{ENV['APP_ROOT']}/#{test_pattern}"].each { |file| require file }
end
