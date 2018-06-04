require 'rubygems'

# If you're using bundler, you will need to add this
require 'bundler/setup'

require 'sinatra'

class SSNetApp < Sinatra::Base
  get '/' do
    erb :index
  end
end