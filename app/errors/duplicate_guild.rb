class DuplicateGuild < ActiveRecord::RecordNotUnique
  def initialize(msg = "The guild name has already be taken")
    super(msg)
  end
end
