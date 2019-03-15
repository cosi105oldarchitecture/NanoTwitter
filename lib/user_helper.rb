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
    User.create(name: params[:name], handle: handle, password: password)
  end
end
