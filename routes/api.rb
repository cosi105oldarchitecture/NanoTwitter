post "#{API_PATH}/login" do
  login(params)
end

post "#{API_PATH}/signup" do
  register_user(params)
end

# API endpoint for creating/posting a new tweet.
  # Pass session token as parameter
  # Use session token to get author_id
  # Decide whether to continue server-side parsing tweet body to extract mentions & hashtags.
  # Add error handling
  # Check that user is logged in
post "#{API_PATH}/tweets/new" do
  if authenticate
    author_id = session[:user].id
    tweet_body = params[:tweet][:body]
    status 201
    set_new_tweet(author_id, tweet_body).to_json
  end
end
