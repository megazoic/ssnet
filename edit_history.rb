require './config/sequel'
module BlogMaker
  class Edit_history < Sequel::Model
    plugin :validation_helpers
    def validate
      super
      validates_presence [:post, :au_id, :created_at]
    end
  end
end
