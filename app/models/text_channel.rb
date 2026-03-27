class TextChannel < Channel
  belongs_to :guild, foreign_key: :guild_id, primary_key: :id, optional: true
  validates :guild_id, presence: true
  has_and_belongs_to_many :users, through: :guild

  def as_json
    super(only: [ :id, :name, :description, :type, :guild ])
  end
end
