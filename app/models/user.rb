class User < ApplicationRecord
  has_secure_password
  before_save :generate_uuid, unless: :uuid?

  def as_json
    super(only: [ :uuid, :email, :profile_picture_path, :username ])
  end

  def temporary_password(password)
    BCrypt::Password.new(password)
  end

  def generate_password(password)
    BCrypt::Password.create(password)
  end

  private
  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  normalizes :email, with: ->(e) { e.strip.downcase }
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :profile_picture_path, presence: true
end
