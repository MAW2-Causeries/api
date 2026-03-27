class TextChannel < Channel
  belongs_to :guild, foreign_key: :guild_id, primary_key: :id, optional: true
  validates :guild_id, presence: true
  has_many :users, through: :guild, source: :members

  def as_json
    super(only: [ :id, :name, :description, :type, :guild ])
  end
end
