class Guild < ApplicationRecord
  has_many :channels, foreign_key: :guild_id, primary_key: :uuid, dependent: :destroy
  belongs_to :user, foreign_key: :owner_id, primary_key: :uuid
  belongs_to :user, foreign_key: :creator_id, primary_key: :uuid
  before_save :generate_uuid, unless: :uuid?

  def as_json
    super(only: [ :uuid, :name, :owner_id, :description ])
  end

  private
  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  validates :name, presence: true, uniqueness: true
  validates :banner_picture_path, presence: true
  validates :creator_id, presence: true
  validates :owner_id, presence: true
end
