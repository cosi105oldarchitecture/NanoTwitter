describe 'POST on /tweets/new' do
  it 'can post a new tweet' do
    post "/login", handle: '@ari', password: 'ari123'
    post "#{API_PATH}/tweets/new", tweet: { body: 'Scalability is fun!' }
    last_response.status.must_equal 201
  end

  it 'will not post a new tweet without authentication' do
    post "#{API_PATH}/tweets/new", tweet: { body: 'Scalability is fun!' }
    last_response.status.must_equal 401
  end
end
