# [Odinbook](https://www.theodinproject.com/courses/ruby-on-rails/lessons/final-project#project-building-facebook) [(Heroku deployed)](https://ovsjazz-odinbook.herokuapp.com/users/sign_in)

## About
Facebook clone, where users can send friend requests, post and comment on posts. User can sign-in/sign-up using sso via Google, Twitter or Facebook accounts.

## Guidelines
1. Add `gem 'devise'`
2. Run the generator `rails g devise:install`
3. Create a user model `rails g devise User username email`
4. Generate devise controllers and views to override the sign-in/sign-up process with `rails g devise:controllers users -c registrations sessions passwords`, `rails g devise:views users -v registrations sessions passwords`

5. Set up `config/routes.rb`
```
devise_for :users, controllers: {
  omniauth_callbacks: 'users/omniauth_callbacks',
  registrations: 'users/registrations',
  passwords: 'users/passwords',
  sessions: 'users/sessions'
}
```

6. Set up login via username or email. Add `config.authentication_keys = [:login]` to `config/initializers/devise.rb`. Add this code to `User`
```
attr_writer :login

class << self
  def find_for_database_authentication(warden_conditions)
    if login = warden_conditions[:login]
      where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).take
    elsif warden_conditions.has_key?(:username) || warden_conditions.has_key?(:email)
      where(warden_conditions).take
    end
  end
end

def login
  @login || username || email
end
```
Add this to `app/controllers/users/sessions_controller.rb`
```
def configure_sign_in_params
  devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
end
```

7. Set up Single Sign-On (SSO) for logging in with Google, Facebook, Twitter by adding
```
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
```
to Gemfile

8. Modify User model to include omniauthable in `app/models/user.rb`
```
PROVIDERS = %w[facebook google_oauth2 twitter]

devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: PROVIDERS

def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.username = auth.info.name
  end
end
```
Generate migration `rails g migration AddOmniauthToUsers provider uid` and migrate `rails db:migrate`

9. Edit `config/initializers/devise.rb`
```
User::PROVIDERS.each do |provider|
  upcased = provider.split('_').first.upcase
  config.omniauth provider,
  ENV["#{upcased}_KEY"],
  ENV["#{upcased}_SECRET"],
  callback_url: ENV["#{upcased}_CALLBACK_URL"]
end
```
and provide api credentials for SSO, optional add `gem 'dotenv-rails'`, create `.env` file and add
```
GOOGLE_KEY = ''
GOOGLE_SECRET = ''
GOOGLE_CALLBACK_URL = http://localhost:3000/users/auth/google_oauth2/callback

FACEBOOK_KEY = ''
FACEBOOK_SECRET = ''
FACEBOOK_CALLBACK_URL = http://localhost:3000/users/auth/facebook/callback

TWITTER_KEY = ''
TWITTER_SECRET = ''
TWITTER_CALLBACK_URL = http://localhost:3000/users/auth/twitter/callback
```
Add `.env` to gitignore

10. Add SSO links to sign-in/sign-up views. They are generated by devise and initially are in `app/views/users/shared/_links.html.erb`
```
<% if devise_mapping.omniauthable? %>
  <% resource_class.omniauth_providers.each do |provider| %>
    <%= link_to omniauth_authorize_path(resource_name, provider), class: "btn btn-block btn-secondary" do %>
      <%= icon 'fab', provider.split('_').first, class: 'mr-2' %>
      Sign in with <%= provider.split('_').first.capitalize %>
    <% end %>
  <% end %>
<% end %>
```
