

1. \# Gemfile

	```
	gem ‘omniauth’
	gem ‘omniauth-douban-oauth2’
	gem ‘devise’
	gem ‘nifty-generators’
	```

2. \# config/initializers/omniauth.rb

	```
	Rails.application.config.middleware.use OmniAuth::Builder do
	  provider :douban, '0870d2c5294321761952784f7bc96462', '5023967771ddefcd'

	end
```

3. generate model Authentication

	```
	rails g nifty:authentication user_id:integer uid:string provider:string index create destroy
	rake db:migrate
	```

4. generate association between User and Authentication

	```
	\# user.rb
	has_many :authentications
	
	```

5. \# config/routes.rb

	```
	match ‘/auth/:provider/callback’ => ‘authentications#create’
	```

6. request `/auth/douban`, redirect to callback and handle

	```
	class AuthenticationsController
		def create
			auth = request.env['omniauth']
			...
		end
	end
	```