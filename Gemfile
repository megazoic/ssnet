# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "rails"

gem 'sinatra'
gem "activerecord"
gem "sinatra-activerecord"
gem 'sinatra-flash'
gem 'sinatra-redirect-with-flash'
gem 'rake'

group :development do
 gem 'sqlite3'
 gem "tux"
end

group :production do
 gem 'pg'
end
