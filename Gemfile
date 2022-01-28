source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails', '~> 6.0.4', '>= 6.0.4.4'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'webpacker', '~> 4.0'
gem 'jbuilder', '~> 2.7'
gem 'faraday'
gem 'slim-rails'
gem 'rubyzip', require: 'zip'
gem 'active_model_serializers'
gem 'kaminari'
gem 'uglifier'

group :development, :test do
  gem 'dotenv-rails', require: 'dotenv/rails-now'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 5.0.0'
end

group :development do
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'factory_bot_rails'
  gem 'faker'
end
