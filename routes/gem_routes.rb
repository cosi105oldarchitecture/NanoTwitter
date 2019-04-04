post "#{API_PATH}/login/:handle/:password" do
  login(params)
end

post "#{API_PATH}/signup/:name/:handle/:password" do
  register_user(params)
end

post "#{API_PATH}/tweets/new/:handle/:password/:tweet_body" do
  login(params)
  if authenticate
    status 201
    new_tweet = set_new_tweet(
      session[:user].id,
      session[:user].handle,
      params[:tweet_body]
    )
    new_tweet_fanout(new_tweet.id)
    new_tweet.to_json
  end
end

post "#{API_PATH}/tweets/:handle/:password" do
  login(params)
  if authenticate
    session[:user].timeline_tweets.to_json
  end
end

post "#{API_PATH}/users/followers/:handle/:password" do
  login(params)
  if authenticate
    response = []
    session[:user].followers.map do |follower|
      response << {
        name: follower.name,
        handle: follower.handle
      }
    end
    response.to_json
  end
end

post "#{API_PATH}/users/followees/:handle/:password" do
  login(params)
  if authenticate
    response = []
    session[:user].followees.map do |followee|
      response << {
        name: followee.name,
        handle: followee.handle
      }
    end
    response.to_json
  end
end

post "#{API_PATH}/users/follow/:handle/:password/:followee_handle" do
  login(params)
  followee = nil
  if authenticate
    followee = User.find_by(handle: params[:followee_handle])
    return { error: 'Invalid followee handle.' }.to_json if followee.nil?
    follow(session[:user].id, followee.id)
  end
  { name: followee.handle }.to_json
end
