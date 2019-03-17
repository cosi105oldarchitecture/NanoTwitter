describe 'Tweet Helper' do
  it 'can get hashtags and mentions' do
    set_new_tweet(@ari.id, '@brad isnt #scalability the #best thing ever?')
    tweet = @ari.tweets.last
    tweet.mentions.count.must_equal 1
    tweet.mentions.first.mentioned_user.must_equal @brad
    tweet.hashtags.count.must_equal 2
    tweet.hashtags.first.name.must_equal '#scalability'
    tweet.hashtags.second.name.must_equal '#best'
  end
end
