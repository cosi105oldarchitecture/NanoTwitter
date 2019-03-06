describe 'User model' do

  it 'has 4 users' do
    User.count.must_equal 4
  end

  it 'can destroy a user' do
    @ari.destroy
    User.count.must_equal 3
  end

  it 'requires an email and a password' do
    chi = User.new(name: 'Chi', password: 'chi123')
    chi.save.must_equal false

    chi = User.new(name: 'Chi', email: 'chi@nt.com')
    chi.save.must_equal false
  end

  it 'requires a unique email' do
    fake_ari = User.new(name: 'Ari', email: @ari.email, password: 'identitytheftisnotajoke')
    fake_ari.save.must_equal false
  end

end
