# config.ru
require './ssnet'
#development
#SSNetApp.run! :port => 3000, :bind => '0.0.0.0'
#production
use Rack::ShowExceptions
run SSNetApp.new