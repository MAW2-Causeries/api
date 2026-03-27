class DMChannel < Channel
  has_and_belongs_to_many :users,
    join_table: :channels_users,
    foreign_key: :channel_id,
    association_foreign_key: :user_id

  validates :guild_id, absence: true
  validates :users, length: { is: 2 }, if: -> { guild_id.blank? }
  validate :unique_user_pair, if: -> { guild_id.blank? && user_ids.uniq.size == 2 }

  def as_json
    json = super(only: [ :id, :name, :description, :type ])

    for user in users
      json[:users] ||= []
      json[:users] << user.as_json
    end
    json
  end

  scope :between_users, ->(users) {
    joins(:users).where(users: { id: users }).first
  }

  before_validation :set_default_name, on: :create

  def set_default_name
    self.name = "#{users.map(&:username).join(' & ')} Private Conversation" if name.blank?
  end

  private

  def unique_user_pair
    duplicate_exists = self.class
      .joins(:users)
      .where(users: { id: user_ids.uniq })
      .where.not(id: id)
      .group("channels.id")
      .having("COUNT(DISTINCT users.id) = ?", user_ids.uniq.size)
      .exists?

    return unless duplicate_exists

    errors.add(:users, "pair already has a DM channel with this user")
  end
end
