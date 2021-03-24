# chat_app

# Required installations:
- Ruby 2.7.2
- Rails 5
- Redis
- SideKiq
- ElasticSearch
- MySql

# Steps:
- bundle install
- rails s
- bundle exec sidekiq

# Endpoints:
- GET ``` /api/v1/applications ```     &rightarrow; views all application
- POST ```/api/v1/applications```    &rightarrow; creates an application and returns token
- GET ```/api/v1/applications/[acess_token]```  &rightarrow; view application of id 

- GET ```/api/v1/application/[acess_token]/chats``` &rightarrow; view all chats of application
- POST ```/api/v1/application/[acess_token]/chats``` &rightarrow; creates a new chat of application
- GET ```/api/v1/application/[acess_token]/chats/[number]``` &rightarrow; views chat

- GET ```/api/v1/application/[acess_token]/chats/[number]/messages``` &rightarrow; views messages
- GET ```/api/v1/application/[acess_token]/chats/[number]/messages?search_query=[query]``` &rightarrow; search a message
- POST ```/api/v1/application/[acess_token]/chats/[number]/messages``` &rightarrow; creates new message -- data{'body': text }
- GET ```/api/v1/application/[acess_token]/chats/[number]/messages/[number]``` &rightarrow; views message

# Remarks:
- The update of the msgs_count and chats_count is down with cached_counts &rightarrow; updates database on Create of messages and Chats
- The numbering of each of the entities is down using $redis.incr
- Create of the chats and messages are done in a background job by sidekiq &rightarrow; room for improvement in this area
- Redis caching expires every hour to get the updated msgs_count and chats_count &rightarrow; requires improvement

# To Add:
- Dockerization
- Rspec
- More Testing
