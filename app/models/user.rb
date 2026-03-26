class User < ApplicationRecord
  has_many :guilds, foreign_key: :owner_id, primary_key: :id
  has_many :guilds, foreign_key: :creator_id, primary_key: :id
  has_secure_password
  include HasUuid
  before_save :generate_id, unless: :id?

  def as_json
    super(only: [ :id, :email, :profile_picture_path, :username ])
  end

  def load_password_hash(password)
    BCrypt::Password.new(password)
  end

  def encode_password(password)
    BCrypt::Password.create(password)
  end

  normalizes :email, with: ->(e) { e.strip.downcase }
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :profile_picture_path, presence: true
end
