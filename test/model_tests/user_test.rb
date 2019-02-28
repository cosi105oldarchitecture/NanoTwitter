describe 'User model' do
  before do
    @ari = User.create(name: 'Ari', email: 'ari@nanotwitter.com', password: 'ari_pwd')
    @brad = User.create(name: 'Brad', email: 'brad@nanotwitter.com', password: 'brad_pwd')
    @yang = User.create(name: 'Yang', email: 'yang@nanotwitter.com', password: 'yang_pwd')
  end

  it 'has 3 users' do
    User.count.must_equal 3
  end

end
