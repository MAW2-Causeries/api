class TextChannel < Channel
  validates :guild_id, presence: true

  def as_json
    super(only: [ :id, :name, :description, :type, :guild ])
  end
end
