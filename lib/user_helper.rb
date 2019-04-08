def login(params)
  if user = Register.authenticate(params)
    session[:user] = user
    status 201
  else
    status 401
  end
end

def register_user(params)
  handle = params[:handle].downcase
  password = params[:password]
  if handle.blank? || password.blank? || !User.find_by(handle: handle).nil?
    status 403
    nil
  else
    status 201
    session[:user] = User.create(name: params[:name], handle: handle, password: password)
  end
end

def follow(follower_id, followee_id)
  Thread.new do
    Follow.create(follower_id: follower_id, followee_id: followee_id)
    HTTParty.post("#{ENV['FANOUT_URL']}/new_follower/#{followee_id}/#{follower_id}")
  end
end
