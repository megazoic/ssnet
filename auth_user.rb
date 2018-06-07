require_relative './config/sequel'
require 'bcrypt'

module BlogMaker
  class Auth_user < Sequel::Model
  end
end