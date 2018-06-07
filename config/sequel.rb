require 'sequel'
#for remote use Heroku
#DB = Sequel.connect(ENV['DATABASE_URL'])
#for local use
DB = Sequel.connect('postgres://dev_ssnet:2BsafeTE@localhost:5432/ssnet')