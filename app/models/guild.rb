class Guild < ApplicationRecord
  has_many :channels, foreign_key: :guild_id, primary_key: :id, dependent: :destroy
  has_many :invites, class_name: "GuildInvite", foreign_key: :guild_id, primary_key: :id, dependent: :destroy
  belongs_to :owner, class_name: "User", foreign_key: :owner_id, primary_key: :id
  belongs_to :creator, class_name: "User", foreign_key: :creator_id, primary_key: :id
  has_and_belongs_to_many :members,
    class_name: "User",
    join_table: :guilds_users,
    foreign_key: :guild_id,
    association_foreign_key: :user_id

  include HasUuid

  def invite_member!(user)
    return user if members.exists?(id: user.id)

    members << user
    user
  end

  def as_json
    super(only: [ :id, :name, :owner_id, :description ])
  end

  validates :name, presence: true
  attribute :description, :string, default: ""
  validates :creator_id, presence: true
  validates :owner_id, presence: true
end
