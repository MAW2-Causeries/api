class User < ApplicationRecord
  has_secure_password
  before_save :generate_uuid, unless: :uuid?


  def as_json
    super(only: [ :uuid, :email, :profile_picture_path, :username ])
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
