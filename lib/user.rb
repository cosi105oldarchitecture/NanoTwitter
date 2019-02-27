require 'bcrypt'
require 'yaml'
require 'json'

class User
  include BCrypt
  attr_reader :name
  
  def self.authenticate(params = {})
  
    return nil if params[:username].blank? || params[:password].blank?

    file = File.read('file.json')
    if file.empty?
      return nil
    else
      data = JSON.parse(file)
    end

    username = params[:username].downcase
    if data.nil?
      return nil
    end
    if data.key?(username)
      password_hash = Password.new(data[username])
      if password_hash == params[:password]
        return User.new(username)
      end
    end
    return nil
  end
  
  def initialize(username)
    @name = username.capitalize
  end
end