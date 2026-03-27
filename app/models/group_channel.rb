class GroupChannel < Channel
  has_and_belongs_to_many :users,
    join_table: :channels_users,
    foreign_key: :channel_id,
    association_foreign_key: :user_id
  validates :guild_id, absence: true
  before_validation :set_default_name, on: :create

  def as_json
    json = super(only: [ :id, :name, :description, :type ])

    json["users"] = users.as_json
    json
  end

  private

  def set_default_name
    if name.blank? && users.any?
      self.name = users.map(&:username).join(", ")
    end
  end
end
