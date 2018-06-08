require 'sequel'
#for remote use Heroku
#DB = Sequel.connect(ENV['DATABASE_URL'])
#for local use
db_conn_url = File.open("./db/db_conn_url.txt", "r"){ |file| file.read }
DB = Sequel.connect(db_conn_url)