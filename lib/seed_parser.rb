require 'csv'
Dir["#{ENV['APP_ROOT']}/models/*.rb"].each { |file| require file }

# SeedParser encapsulates conditional database seeding,
# such as specifying the number users to seed.
class SeedParser
  attr_reader :user_hash, :users_seeded, :user_cap, :tweets_seeded, :tweet_cap

  def initialize
    @user_cap = nil
    @tweet_cap = nil
    import_users
    import_tweets
    import_follows
    import_timelines
    # Check whether test user already exists first!!!
    User.create(id: User.last.id + 1, name: 'testuser', handle: 'testuser@sample.com', password: 'password')
  end

  # Seeds N users and their data in associated tables.
    # e.g. options = {tweets: 100}
  def seed_users(num_users, options={})

    options[:tweets].nil

    @user_hash.keys[0...num_users].each do |user_id|
      # ...
    end
  end

  # Inserts all data associated with a user into the db
  def seed_user_data(user_id, options={ 'tweets': nil })
    user_data = @user_hash[user_id.to_sym]
    info = user_data[:user_row]
    User.create(id: user_id, name: info[1], handle: "@#{info[1] << info[0]}".downcase, password: "@#{info[1] << info[0]}".downcase)
    @users_seeded += 1

    user_data[:tweets].each do |row|
      if options[:tweets].nil || @tweets_seeded <= options[:tweets]
        Tweets.create(author_id: user_id, body: row[1], created_on: row[2])
        @tweets_seeded += 1
      end
    end
    user_data[:timeline_pieces].each { |row| TimelinePiece.create(timeline_owner_id: user_id, tweet_id: row[1]) }
    user_data[:follower_rows].each { |row| Follow.create(follower_id: user_id, followee_id: row[1]) }
    user_data[:followee_rows].each { |row| Follow.create(follower_id: row[0], followee_id: user_id) }
  end

  def import_users
    CSV.foreach("#{ENV['APP_ROOT']}/db/seed_files/users.csv") do |row|
      @user_hash[row[0].to_sym] = {
        'user_row': row,
        'tweet_rows': [],
        'follower_rows': [],
        'followee_rows': [],
        'timeline_rows': []
      }
    end
  end

  def import_follows
    CSV.foreach("#{ENV['APP_ROOT']}/db/seed_files/follows.csv") do |row|
      @user_hash[row[0].to_sym][:follower_rows] << row
      @user_hash[row[1].to_sym][:followee_rows] << row
    end
  end

  def import_tweets
    CSV.foreach("#{ENV['APP_ROOT']}/db/seed_files/tweets.csv") do |row|
      row = DateTime.strptime(row[-1], '%Y-%m-%d %H:%M:%S %z') # Format datetime
      @user_hash[row[0].to_sym][:tweet_rows] << row
    end
  end

  def import_timelines
    CSV.foreach("#{ENV['APP_ROOT']}/db/seed_files/timeline_pieces.csv") do |row|
      @user_hash[row[0].to_sym][:timeline_pieces] << row
    end
  end
end
