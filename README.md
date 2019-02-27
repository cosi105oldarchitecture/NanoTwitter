# NanoTwitter

[![Codeship Status for cosi105/NanoTwitter](https://app.codeship.com/projects/ec59bc70-1c93-0137-a172-0eda4e30ac77/status?branch=master)](https://app.codeship.com/projects/328870)

Authors
* Yang Shang
* Ari Carr
* Brad Nesbitt

NanoTwitter is a light version of twitter, implemented in Ruby with Sinatra.


# Initializes the db's Follow table
class CreateFollowTable < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.integer :follower_id
      t.integer :followee_id
    end
  end
end

# Initializes the db's Tweet table
class CreateTweetTable < ActiveRecord::Migration[5.2]
  def change
    create_table :tweet do |t|
      t.string :body
      t.datetime :created_on
      t.integer :author_id
    end
  end
end

