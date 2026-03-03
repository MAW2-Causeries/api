class Channel < ApplicationRecord
  belongs_to :guilds, foreign_key: :guild_id, primary_key: :uuid, optional: true
  include HasUuid

  def as_json
    super(only: [ :uuid, :name, :category, :guild_id, :description ])
  end

  def reformatted_name
    self.name.gsub(' ','-').gsub(/[^0-9A-Za-z\s]/, '').downcase
  end

  validates :name, presence: true, uniqueness: { scope: [ :guild_id, :category ] }
  validates :category, presence: true
end
