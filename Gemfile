source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'angular-rails-templates'

gem 'responders'

gem 'angular_rails_csrf'

gem 'devise', '~> 3.4.0'

gem 'git', '~> 1.11.0'

gem 'fb_graph2', '~> 0.9.1'

gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

gem 'subprocess', '~> 1.3.2'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :production do
  gem 'unicorn'
end

group :development, :test do
  gem 'rspec-rails'
  # Call 'byebug' anywhere in the code to stop
  # execution and get a debugger console
  gem 'byebug'
  gem 'rubocop', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running
  # in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'annotate'
end
