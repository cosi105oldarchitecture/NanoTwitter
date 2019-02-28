require 'bcrypt'
require 'yaml'

class Register
  include BCrypt
  attr_reader :name

  def self.authenticate(params = {})
    return nil if params[:email].blank? || params[:password].blank?
    email = params[:email].downcase
    target_user = User.find_by(email: email)
    if !target_user.nil? && target_user.authenticate(params[:password])
      return Register.new(email)
    end
    nil
  end

  def initialize(email)
    @name = email.capitalize
  end
end
