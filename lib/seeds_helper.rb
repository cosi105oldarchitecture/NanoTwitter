def get_csv(model)
  CSV.read("#{ENV['APP_ROOT']}/db/seed_files/#{model}.csv")
end

require 'csv'
def seed_users(count)
  user_rows = get_csv('users')
  i = 0
  total = count || user_rows.count
  user_rows.each do |row|
    break if i == count
    User.new(id: row[0], name: row[1], handle: "@#{row[1] << row[0]}".downcase, password: "@#{row[1] << row[0]}".downcase).save(validate: false)
    puts "User #{i += 1} / #{total}"
  end
end

def seed_follows(count)
  follow_rows = get_csv('follows')
  i = 0
  total = count || follow_rows.count
  user_count = User.count
  follow_rows.each do |row|
    break if i == count || row[0].to_i > user_count
    next if row[1].to_i > user_count
    follower = User.find(row[0])
    followee = User.find(row[1])
    Follow.new(
      follower_id: row[0],
      followee_id: row[1],
      follower_handle: follower.handle,
      followee_handle: followee.handle
    ).save(validate: false)
    puts "Follow #{i += 1} / #{total}"
  end
end

def seed_tweets(count)
  tweet_rows = get_csv('tweets')
  i = 0
  total = count || tweet_rows.count
  user_count = User.count
  tweet_rows.each do |row|
    break if i == count || row[0].to_i > user_count
    author = User.find(row[0])
    Tweet.new(
      author_id: row[0],
      body: row[1],
      created_on: DateTime.strptime(row[2],'%Y-%m-%d %H:%M:%S %z'),
      author_handle: author.handle
    ).save(validate: false)
    puts "Tweet #{i += 1} / #{total}"
  end
end

def seed_testuser
  id = User.last.nil? ? 0 : User.last.id
  User.create(id: id + 1, name: 'testuser', handle: 'testuser@sample.com', password: 'password')
end

def delete_all
  ActiveRecord::Base.subclasses.each(&:delete_all)
end
