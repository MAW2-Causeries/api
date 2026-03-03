# app/models/concerns/has_uuid.rb
module HasUuid
  extend ActiveSupport::Concern

  included do
    before_create :generate_uuid
  end

  private

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end
end