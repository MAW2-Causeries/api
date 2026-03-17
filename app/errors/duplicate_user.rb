class DuplicateUser < ActiveRecord::RecordNotUnique
  def initialize(msg = "The username and/or email has already been taken")
    super(msg)
  end
end
