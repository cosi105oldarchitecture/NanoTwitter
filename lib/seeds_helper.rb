def get_csv(model)
  CSV.read("#{ENV['APP_ROOT']}/db/seed_files/#{model}.csv")
end

require 'csv'
Dir["#{ENV['APP_ROOT']}/models/*.rb"].each { |file| require file }

def seed_users(count)
  user_rows = get_csv('users')
  i = 0
  total = count || user_rows.count
  user_rows.each do |row|
    break if i == count
    User.create(id: row[0], name: row[1], handle: "@#{row[1] << row[0]}".downcase, password: "@#{row[1] << row[0]}".downcase)
    puts "User #{i += 1} / #{total}"
  end
end

def seed_follows(count)
  follow_rows = get_csv('follows')
  i = 0
  total = count || follow_rows.count
  follow_rows.each do |row|
    unless count.nil?
      break if row[0].to_i > count
      next if row[1].to_i > count
    end
    Follow.create(follower_id: row[0], followee_id: row[1])
    puts "Follow #{i += 1} / #{total}"
  end
end

def seed_tweets(count)
  tweet_rows = get_csv('tweets')
  i = 0
  total = count || tweet_rows.count
  tweet_rows.each do |row|
    break if i == count
    Tweet.create(author_id: row[0], body: row[1], created_on: DateTime.strptime(row[2], '%Y-%m-%d %H:%M:%S %z'))
    puts "Tweet #{i += 1} / #{total}"
  end
end

def seed_testuser
  User.create(id: User.count + 1, name: 'testuser', handle: 'testuser@sample.com', password: 'password')
end

def delete_all
  User.delete_all
  Follow.delete_all
  Tweet.delete_all
end
