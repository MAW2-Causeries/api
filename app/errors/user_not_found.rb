class UserNotFound < ActiveRecord::RecordNotFound
    def initialize(msg = "The user was not found")
      super(msg)
    end
end
