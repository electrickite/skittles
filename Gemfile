source 'https://rubygems.org'

# Workaround for Bundler bug: https://github.com/bundler/bundler/issues/5476
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.1'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

gem 'jquery-rails'
gem 'js-routes'
gem 'dotenv-rails'
gem 'chess'
gem 'stockfish'
gem 'devise'
gem 'bootstrap-sass'
gem 'simple_form'
gem 'active_link_to'
gem 'cancancan', '~> 2.0'
gem 'redis', '~> 3.0'
gem 'griddler'
gem 'griddler-mailgun'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'mysql2', group: :mysql

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'sqlite3'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', '~> 3.8'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-passenger'
  gem 'capistrano-chruby'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
