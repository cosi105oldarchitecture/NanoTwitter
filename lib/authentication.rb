module Authentication
  def authenticate
    unless session[:user]
      status 401
      false
    else
      true
    end
  end

  def authenticate_or_home!
    redirect '/' unless authenticate
  end
end
