# See https://redis.io/topics/mass-insert


# Generates valid Redis protocol (for mass insertion)
def gen_redis_proto(*cmd)
  proto = ""
  proto << "*" + cmd.length.to_s + "\r\n"
  cmd.each { |arg|
      proto << "$" + arg.to_s.bytesize.to_s + "\r\n"
      proto << arg.to_s + "\r\n"
  }
  proto
end

def test_proto
  puts 'FIRST PIECE:'
  puts TimelinePiece.first.tweet_body
  result = ''
  (0...5).each{|n|
    result << gen_redis_proto("HMSET","testhash","Key#{n}","Value#{n}")
  }
  open('./db/redis_seed_test.txt', 'w') do |file|
    file << result
  end
end

def write_redis_seed
  result = ''

  TimelinePiece.all.each do |record|
    result << gen_redis_proto(
      'HMSET', # Redis command for set hash
      'timeline_pieces', # Name of hash
      'piece:id', record.id.to_s, # First Key:Value pair
      'owner:id', record.timeline_owner_id.to_s,
      'tweet:id', record.tweet_id.to_s,
      'tweet:body', record.tweet_body.to_s,
      'tweet:created_on', record.tweet_created_on.to_s,
      'tweet:author_handle', record.tweet_author_handle.to_s
    )
  end
  open('./db/redis_seed.txt', 'w') do |file|
    file << result
  end
end
