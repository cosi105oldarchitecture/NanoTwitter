def get_csv(model)
  CSV.read("#{ENV['APP_ROOT']}/db/seed_files/#{model}.csv")
end

def load_seed(model_params, model_class)
  i = 0
  model_params.each do |params|
    model_class.create(params)
    puts "#{model_class.name} #{i += 1} / #{model_params.size}"
  end
end

require 'csv'
Dir["#{ENV['APP_ROOT']}/models/*.rb"].each { |file| require file }
# user_rows = get_csv('users')
# tweet_rows = get_csv('tweets')
# follow_rows = get_csv('follows')

# mapped_user_rows = user_rows.map { |row| {id: row[0], name: row[1], handle: "@#{row[1] << row[0]}".downcase, password: "@#{row[1] << row[0]}".downcase} }

# mapped_follow_rows = follow_rows.map { |row| { follower_id: row[0], followee_id: row[1] }}

# mapped_tweet_rows = tweet_rows.map { |row| { author_id: row[0], body: row[1], created_on: DateTime.strptime(row[2], '%Y-%m-%d %H:%M:%S %z') } }

# [[mapped_user_rows, User], [mapped_tweet_rows, Tweet], [mapped_follow_rows, Follow]].each { |arr| load_seed(arr[0], arr[1]) }

# User.create(id: User.last.id + 1, name: 'testuser', handle: 'testuser@sample.com', password: 'password')

# Tweet.all.each { |t| set_timelines(t) }

def seed_users(count)
	user_rows = get_csv('users')
	i = 0
	user_rows.each do |row|
		break if i = count
		User.create(id: row[0], name: row[1], handle: "@#{row[1] << row[0]}".downcase, password: "@#{row[1] << row[0]}".downcase)
		i = i + 1
	end
end

def seed_follows(count)
	follow_rows = get_csv('follows')
	follow_rows.each do |row|
		break if row[0] > count
		next if row[1] > count
		Follow.create(follower_id: row[0], followee_id: row[1])
	end
end

def seed_tweets(count)
	tweet_rows = get_csv('tweets')
	tweet_rows.each do |row|
		break if row[0] > count
		Tweet.create(author_id: row[0], body: row[1], created_on: DateTime.strptime(row[2], '%Y-%m-%d %H:%M:%S %z'))
	end
end

def seed_testuser
	User.create(id: User.last.id + 1, name: 'testuser', handle: 'testuser@sample.com', password: 'password')
end

def delete_all
	User.delete_all
	Follow.delete_all
	Tweet.delete_all
end












