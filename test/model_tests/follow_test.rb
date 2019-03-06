describe 'follows' do
  before do
    @brad.follow(@ari)
  end

  it 'can tell how many people are following Ari' do
    @ari.followers.count.must_equal 1
  end

  it 'can tell how many people Brad is following' do
    @brad.followees.count.must_equal 1
  end

  it 'can handle multiple followers' do
    [@yang, @pito].each { |u| u.follow @ari }
    @ari.followers.count.must_equal 3
    [@brad, @yang, @pito].each { |u| u.followees.count.must_equal 1 }
  end

  it 'can handle multiple followees' do
    [@yang, @pito].each { |u| @brad.follow u }
    @brad.followees.count.must_equal 3
    [@ari, @yang, @pito].each { |u| u.followers.count.must_equal 1 }
  end

  it 'will not let Brad follow Ari twice' do
    f = Follow.new(follower_id: @brad.id, followee_id: @ari.id)
    f.save.must_equal false
  end

  it 'will not let Ari follow himself' do
    f = Follow.new(follower_id: @ari.id, followee_id: @ari.id)
    f.save.must_equal false
  end

  it 'will let Ari follow Brad even though Brad already follows Ari' do
    f = Follow.new(follower_id: @ari.id, followee_id: @brad.id)
    f.save.must_equal true
    @ari.followees.count.must_equal 1
    @brad.followers.count.must_equal 1
  end

  it 'will let follows be created from the follower' do
    @ari.followees << @brad
    Follow.count.must_equal 2
    @ari.followees.count.must_equal 1
    @brad.followers.count.must_equal 1
  end

  it 'will let follows be created from the followee' do
    @brad.followers << @ari
    Follow.count.must_equal 2
    @ari.followees.count.must_equal 1
    @brad.followers.count.must_equal 1
  end
end
