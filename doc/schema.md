**DB Diagram: [https://dbdiagram.io/d/5c7430a6f7c5bb70c72f1eb8]()**

User

- name: string
- email: string
- password: digest
- api_token: text
- has_many follows, as follower
- has_many follows, as followee
- has_many tweets, as author
- has_many timeline\_pieces

Follow

- follower: int (user id)
- followee: int (user id)
- belongs_to user

Tweet

- body: text (280-char limit)
- created_at: datetime
- author: int (user id)
- belongs_to user
- has_many mentions
- has_many tweet\_tags
- has_many timeline\_pieces

Hashtag

- name: string
- has_many tweet\_tags

TweetTag

- hashtag_id: int
- tweet_id: int
- belongs_to hashtag
- belongs_to tweet

Mention

- user_id: int
- tweet_id: int
- belongs_to user
- belongs_to tweet

TimelinePiece

- user_id: int
- tweet_id: int
- belongs_to user
- belongs_to tweet