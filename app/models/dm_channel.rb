class DMChannel < Channel
  has_and_belongs_to_many :users,
    join_table: :channels_users,
    foreign_key: :channel_id,
    association_foreign_key: :user_id

  validates :guild_id, absence: true
  validates :users, length: { is: 2 }

  validate :unique_user_pair, if: -> { user_ids.uniq.size == 2 }
  validate :users_must_be_different

  def as_json
    json = super(only: [ :id, :name, :description, :type ])

    for user in users
      json[:users] ||= []
      json[:users] << user.as_json
    end
    json
  end

  scope :between_users, ->(user1, user2) {
    joins(:users)
      .where(users: { id: [ user1.id, user2.id ] })
      .group("channels.id")
      .having("COUNT(DISTINCT users.id) = 2")
      .first
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

  def users_must_be_different
    errors.add(:users, "must be different users") if user_ids.uniq.size != 2
  end
end
