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

# Writes all TimelinePiece records to Redis
# Stores each user's timeline in a sorted set
def write_redis_seed
  result = ''
  TimelinePiece.all.each do |t|
    result << gen_redis_proto(
      'ZADD', # Add to sorted set
      "#{t.timeline_owner_id}:timeline", # Name/key of sorted set
      t.tweet_created_on.to_f, # Float used to rank/order set member
      "<li>#{t.tweet_body}<br/>-#{t.tweet_author_handle} at #{t.tweet_created_on}</li>" # Timeline piece's HTML
    )
  end
  open('./db/redis_seed.txt', 'w') do |file|
    file << result
  end
end

def seed_timeline_html
  result = ''
  prev_owner_id = nil
  curr_owner_id = nil
  TimelinePiece.all.order(timeline_owner_id: :desc, id: :desc).each do |t|
    if t.timeline_owner_id != curr_owner_id
      prev_owner_id = curr_owner_id
      curr_owner_id = t.timeline_owner_id
    else
      puts 'finish this function!'
    end
    result << "<li>#{t.tweet_body}<br/>-#{t.tweet_author_handle} at #{t.tweet_created_on}</li>" # Timeline piece's HTML
  end
  open('./db/html_seed.txt', 'w') do |file|
    file << gen_redis_proto('SET', result)
  end
end
