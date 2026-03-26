module HasUuid
  extend ActiveSupport::Concern

  included do
    before_create :generate_id
  end

  private

  def generate_id
    self.id = SecureRandom.id
  end
end
