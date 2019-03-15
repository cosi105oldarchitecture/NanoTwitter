describe 'User model' do

  it 'has 4 users' do
    User.count.must_equal 4
  end

  it 'can destroy a user' do
    @ari.destroy
    User.count.must_equal 3
  end

  it 'requires a handle and a password' do
    chi = User.new(name: 'Chi', password: 'chi123')
    chi.save.must_equal false

    chi = User.new(name: 'Chi', handle: '@chi')
    chi.save.must_equal false
  end

  it 'requires a unique handle' do
    fake_ari = User.new(name: 'Ari', handle: @ari.handle, password: 'identitytheftisnotajoke')
    fake_ari.save.must_equal false
  end

  it 'can authenticate a user' do
    @ari.authenticate('ari123').must_equal @ari
    @ari.authenticate('iforgetmypassword').must_equal false
  end

end
