def load_status
  @user_num = User.count
  @follow_num = Follow.count
  @tweet_num = Tweet.count
  @testuser_id = User.find_by(name: 'testuser').id
end
