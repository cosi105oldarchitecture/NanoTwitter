post "#{API_PATH}/login" do
  login(params)
end

post "#{API_PATH}/signup" do
  register_user(params)
end

# API endpoint for creating/posting a new tweet.
post "#{API_PATH}/tweets/new" do
  if authenticate
    status 201
    new_tweet = set_new_tweet(
      session[:user].id,
      session[:user].handle,
      params[:tweet][:body]
    )
    new_tweet_fanout(new_tweet.id)
    new_tweet.to_json
  end
end

# # Return to timeline after posting new tweet.
# after "#{API_PATH}/tweets/new" do
#   redirect('/tweets')
# end
