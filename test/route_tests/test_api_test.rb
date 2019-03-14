include Rack::Test::Methods

describe 'POST on /test/reset/all' do
	it 'Should reset all data' do
		post '/test/reset/all'

		last_response.ok?
		User.count.to_i.must_equal(1001)
		Follow.count.to_i.must_equal(4909)
		Tweet.count.to_i.must_equal(100175)
		
	end
end

describe 'POST on /test/reset' do
	it 'Should reset n users and m tweets' do
		post '/test/reset', 
		{users: 100,
		tweets: 100}

		last_response.ok?
		User.count.to_i.must_equal(101)
		Tweet.count.to_i.must_equal(100)
	end
end

describe 'POST /test/user/:userid/tweets' do
	it 'Should create n tweets for a user' do
		delete_all
		seed_testuser
		post '/test/user/1/tweets',
		{count: 40}

		last_response.ok?
		Tweet.count.to_i.must_equal(40)
	end
end