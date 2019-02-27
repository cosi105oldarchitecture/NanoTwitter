require './app'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'rake/testtask'
require 'pry-byebug'

Rake::TestTask.new do |t|
  t.deps = ['db:test:prepare']
  t.test_files = FileList['test/test_helper.rb']
  t.warning = false
end
