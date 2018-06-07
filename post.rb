require './config/sequel'
module BlogMaker
  class Post < Sequel::Model
    #validates :title, presence: true, length: { minimum: 5 }
    #validates :body, presence: true
    plugin :validation_helpers
    def validate
      super
      validates_presence [:title, :body]
    end
  end
end
