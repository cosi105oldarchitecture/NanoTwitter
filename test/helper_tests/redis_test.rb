describe 'get_redis_object' do
  it 'returns an instance of the Redis class' do
    get_redis_object.class.must_equal(Redis)
  end
end
