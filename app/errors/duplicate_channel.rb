class DuplicateChannel < ActiveRecord::RecordNotUnique
  def initialize(msg = "The channel name has already be taken in this place")
    super(msg)
  end
end
