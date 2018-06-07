# config.ru
require './ssnet'
#need this otherwise the edit form _method doesn't work
use Rack::MethodOverride
run BlogMaker::BLOG.new