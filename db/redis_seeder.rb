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

def write_redis_seed_protocol
  map = {} # Map of each user's timeline HTML
  TimelinePiece.all.order(tweet_created_on: :desc).each do |t|
    # Timeline piece's HTML
    html = "<li>#{t.tweet_body}<br/>-#{t.tweet_author_handle} at #{t.tweet_created_on}</li>"
    key = "#{t.timeline_owner_id}".to_sym
    if map[key].nil? 
      map[key] = ''
    else
      map[key] << html 
    end
  end
  # Generate Redis protocol string for each user's timeline
  redis_protocol = ''
  map.keys.each do |owner_id|
    redis_protocol << gen_redis_proto('SET', "#{owner_id}:timeline_html", map[owner_id.to_sym])
  end
  # Write Redis protocol to seed file
  open('./db/timeline_seed_protocol.txt', 'w') { |file| file << redis_protocol }
end

# # Writes all TimelinePiece records to Redis
# # Stores each user's timeline in a sorted set
# def write_redis_seed
#   result = ''
#   TimelinePiece.all.each do |t|
#     result << gen_redis_proto(
#       'ZADD', # Add to sorted set
#       "#{t.timeline_owner_id}:timeline", # Name/key of sorted set
#       t.tweet_created_on.to_f, # Float used to rank/order set member
#       "<li>#{t.tweet_body}<br/>-#{t.tweet_author_handle} at #{t.tweet_created_on}</li>" # Timeline piece's HTML
#     )
#   end
#   open('./db/redis_seed.txt', 'w') do |file|
#     file << result
#   end
# end

