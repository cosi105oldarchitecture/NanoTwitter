require 'bcrypt'
require 'yaml'

class Register
  include BCrypt
  attr_reader :name

  def self.authenticate(params = {})
    return nil if params[:username].blank? || params[:password].blank?
    username = params[:username].downcase
    target_user = User.find_by(username: username)
    if target_user
      if target_user.authenticate(params[:password])
        return Register.new(username)
      end
    end
    return nil
  end

  def initialize(username)
    @name = username.capitalize
  end
end
