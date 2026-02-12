class Channel < ApplicationRecord
  belongs_to :guilds, foreign_key: :guild_id, primary_key: :uuid, optional: true
  before_save :generate_uuid, unless: :uuid?

  def as_json
    super(only: [ :uuid, :name, :category, :guild_id, :description ])
  end

  private
  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  validates :name, presence: true, uniqueness: { scope: :guild_id } # add index in db for both columns, non null for name + category
  validates :category, presence: true
end
