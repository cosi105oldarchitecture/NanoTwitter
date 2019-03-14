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

describe 'NanoTwitter' do
  before do
    ActiveRecord::Base.subclasses.each(&:destroy_all)
    names = %w[ari brad yang pito]
    users = names.map { |s| User.create(name: s.capitalize, handle: "@#{s}", password: "#{s}123") }
    @ari, @brad, @yang, @pito = users
  end

  Dir["#{ENV['APP_ROOT']}/#{test_pattern}"].each { |file| require file }
end
