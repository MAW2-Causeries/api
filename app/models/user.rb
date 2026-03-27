class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  USERNAME_FORMAT = /\A[A-Za-z0-9]+\z/

  has_many :owned_guilds, class_name: "Guild", foreign_key: :owner_id, primary_key: :id, inverse_of: :owner
  has_many :created_guilds, class_name: "Guild", foreign_key: :creator_id, primary_key: :id, inverse_of: :creator
  has_and_belongs_to_many :guilds,
    join_table: :guilds_users,
    foreign_key: :user_id,
    association_foreign_key: :guild_id
  has_and_belongs_to_many :channels,
    join_table: :channels_users,
    foreign_key: :user_id,
    association_foreign_key: :channel_id
  devise :database_authenticatable, :jwt_authenticatable, jwt_revocation_strategy: self
  include HasUuid
  before_save :generate_id, unless: :id?

  def as_json
    super(only: [ :id, :email, :username ])
  end

  normalizes :email, with: ->(e) { e.strip.downcase }
  validates :username, presence: true, uniqueness: true
  validates :username, format: { with: USERNAME_FORMAT, message: "must contain only letters and numbers" }
  validates :email, presence: true, uniqueness: true
end
