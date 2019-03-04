# NanoTwitter API Documentation

--

# Overview

**Note** Routes start with `/api/v1`  

**Tweets**

* `GET` `/`
* `GET` `/tweets`
* `GET` `/tweets/mentions`
* `POST` `/tweets/new` 

**Users**

* `GET` `/users/followers`
* `GET` `/users/following`
* `POST` `/users/following`

**Log-In**

* `POST` `/login`

**Sign-Up**

* [`POST` `/signup`](#signup)

<br/>
--

# GET /tweets/

### Resource URL  
`GET https://nanotwitter.com/api/v1/tweets`

### Resource Information  
|||
|:--|:--:
|Response Formats|JSON
|Authentication Required?|Yes

### Parameters  
|Key|Required?
|:--|:--|:--
|session_token|Yes

### Example Request  
`GET https://nanotwitter.com/api/v1/tweets`
```
{
	"session_token": "lsfkj12034ikjd103ihf"
}
```

### Example Response
`200 OK` (Successfully retrieved IDs of user's Tweets)
```
{
	"tweet_ids": [91, 12, 65, 152, 12]
}
```
`401 Unauthorized` (Invalid or expired session)  
`500 Internal Server Error`

<br/>
--

# GET /tweets/mentions

### Resource URL  
`GET https://nanotwitter.com/api/v1/tweets/mentions`

### Resource Information  
|||
|:--|:--:
|Response Formats|JSON
|Authentication Required?|Yes

### Parameters  
|Key|Required?
|:--|:--|:--
|session_token|Yes

### Example Request  
`GET https://nanotwitter.com/api/v1/tweets/mentions`
```
{
	"session_token": "923knfn2934i1nkjbd"
}
```

### Example Response
`200 OK` (Successfully retrieved IDs of Tweets mentioning user)
```
{
	"tweet_ids": [41, 436, 86, 12, 23]
}
```
`401 Unauthorized` (Invalid or expired session)  
`500 Internal Server Error`

<br/>
--

# POST /tweets/new

### Resource URL  
`POST https://nanotwitter.com/api/v1/tweets/new`

### Resource Information  
|||
|:--|:--:
|Response Formats|N/A
|Authentication Required?|Yes

### Parameters  
|Key|Required?
|:--|:--|:--
|session_token|Yes
|body|Yes

### Example Request  
`POST https://nanotwitter.com/api/v1/tweets/new`
```
{
	"session_token": "234khj56hsro",
	"body": "This is most scalable app I've ever used!"
}
```

### Example Response
`200 OK` (Tweet successfully posted)  
`401 Unauthorized` (Invalid or expired session)  
`500 Internal Server Error`

<br/>
--

# GET /users/followers

### Resource URL  
`GET https://nanotwitter.com/api/v1/users/followers`

### Resource Information  
|||
|:--|:--:
|Response Formats|JSON
|Authentication Required?|Yes

### Parameters  
|Key|Required?
|:--|:--|:--
|session_token|Yes

### Example Request  
`GET https://nanotwitter.com/api/v1/users/followers`

```
{
	"session_token": "ldskfj123ewlksdfh8124"
}
```

### Example Response

`200 OK` (Successfully retrieved followers)
```
{
	"user_ids": [11, 32, 25, 2]
}
```
`401 Unauthorized` (Invalid or expired session token)  
`500 Internal Server Error`

<br/>
--

# POST /users/followers

### Resource URL  
`POST https://nanotwitter.com/api/v1/users/followers`

### Resource Information  
|||
|:--|:--:
|Response Formats|JSON
|Authentication Required?|Yes

### Parameters  
|Key|Required?
|:--|:--|:--
|session_token|Yes

### Example Request  
`POST https://nanotwitter.com/api/v1/users/followers`

```
{
	"session_token": "ldskfj123ewlksdfh8124"
}
```

### Example Response

`200 OK`
```
{
	"user_ids": [11, 32, 25, 2]
}
```
`401 Unauthorized` (Invalid or expired session token)  
`500 Internal Server Error`

<br/>
--

# POST /users/following

### Resource URL  
`POST https://nanotwitter.com/api/v1/users/following`

### Resource Information  
|||
|:--|:--:
|Response Formats|N/A
|Authentication Required?|Yes

### Parameters  
|Key|Required?
|:--|:--|:--
|session_token|Yes
|user_id_to_follow|Yes

### Example Request  
`POST https://nanotwitter.com/api/v1/users/following`
```
{
	"session_token": "11sdfkl2304isfj3",
	"user_id_to_follow": 88
}
```

### Example Response
`200 OK` (Successfully following user)  
`401 Unauthorized` (Invalid or expired session token)  
`500 Internal Server Error`

<br/>
--

# GET /users/following

### Resource URL  
`GET https://nanotwitter.com/api/v1/users/following`

### Resource Information  
|||
|:--|:--:
|Response Formats|JSON
|Authentication Required?|Yes

### Parameters  
|Key|Required?
|:--|:--|:--
|session_token|Yes

### Example Request  
`GET https://nanotwitter.com/api/v1/users/following`

```
{
	"session_token": "ldskfj123ewlksdfh8124"
}
```

### Example Response

`200 OK` (Successfully retrieved followed users)
```
{
	"user_ids": [11, 32, 25, 2]
}
```
`401 Unauthorized` (Invalid or expired session token)  
`500 Internal Server Error`

<br/>
--

# POST /login

### Resource URL  
`POST https://nanotwitter.com/api/v1/login`

### Resource Information  
|||
|:--|:--:
|Response Formats|N/A
|Authentication Required?|No

### Parameters  
|Key|Required?
|:--|:--|:--
|email|Yes
|password|Yes

### Example Request  
`POST https://nanotwitter.com/api/v1/login`

```
{
	"email": "acarr@ntwitter.com",
	"password": "mypassword123"
}
```

### Example Response

`200 OK` (Successfully authenticated)  
```
{
	"session_token": "ldskfj123ewlksdfh8124"
}
```
`401 Unauthorized`  
`500 Internal Server Error`

<br/>
--

<a name="signup"><a/>
# POST /signup

### Resource URL  
`POST https://nanotwitter.com/api/v1/signup`

### Resource Information  
|||
|:--|:--:
|Response Formats|N/A
|Authentication Required?|No

### Parameters  
|Key|Required?
|:--|:--|:--
|name|Yes
|email|Yes
|password|Yes

### Example Request  
`POST https://nanotwitter.com/api/v1/signup`

```
{
	"name": "Ari Carr",
	"email": "acarr@ntwitter.com",
	"password": "mypassword123"
}
```

### Example Response

`200 OK` (Account created)  
`403 Forbidden` (Email not unique)  
`500 Internal Server Error`  

<br/>
--