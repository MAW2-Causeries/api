class GuildInvite < ApplicationRecord
  include HasUuid

  belongs_to :guild, foreign_key: :guild_id, primary_key: :id
  belongs_to :creator, class_name: "User", foreign_key: :creator_id, primary_key: :id

  before_validation :assign_token, on: :create

  validates :token, presence: true, uniqueness: true
  validates :creator_id, presence: true
  validates :guild_id, presence: true

  def as_json
    super(only: [ :id, :guild_id, :creator_id, :token, :active, :created_at, :updated_at ]).merge(
      "invite_url" => "/api/v1/guild_invites/#{token}/join"
    )
  end

  private

  def assign_token
    self.token ||= loop do
      candidate = SecureRandom.urlsafe_base64(24)
      break candidate unless self.class.exists?(token: candidate)
    end
  end
end
