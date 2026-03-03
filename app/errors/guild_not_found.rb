class GuildNotFound < ActiveRecord::RecordNotFound
  def initialize(msg = "The guild was not found")
    super(msg)
  end
end
