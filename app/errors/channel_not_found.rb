class ChannelNotFound < ActiveRecord::RecordNotFound
    def initialize(msg = "The channel was not found")
      super(msg)
    end
end
