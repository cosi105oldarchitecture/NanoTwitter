
class Register
  def self.authenticate(params = {})
    return nil if params[:handle].blank? || params[:password].blank?
    handle = params[:handle].downcase
    target_user = User.find_by(handle: handle)
    if !target_user.nil? && target_user.authenticate(params[:password])
      return target_user
    end
    nil
  end
end
