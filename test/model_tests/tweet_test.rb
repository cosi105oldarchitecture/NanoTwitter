describe 'tweets' do

  before do
    @tweet = Tweet.create(author_id: @ari.id, body: 'Scalability!', created_on: DateTime.now)
  end

  it 'can create a tweet' do
    Tweet.count.must_equal 1
  end

  it 'can associate tweets with authors' do
    @ari.tweets.count.must_equal 1
    @tweet.author.must_equal @ari
  end

  it 'can fanout tweets' do
    [@brad, @yang, @pito].each { |u| u.followees << @ari }
    @tweet.fanout
    [@brad, @yang, @pito].each do |u|
      u.timeline_tweets.count.must_equal 1
      u.timeline_tweets.first.must_equal @tweet
    end
  end

  it 'can distribute tweets to new followers' do
    [@brad, @yang, @pito].each { |u| u.follow(@ari) }
    [@brad, @yang, @pito].each do |u|
      u.timeline_tweets.count.must_equal 1
      u.timeline_tweets.first.must_equal @tweet
    end
  end

end
