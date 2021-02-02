class Token < ApplicationRecord
  EXPIRATION_TIME = 2.hours

  # validations
  validates :permissions, presence: true, inclusion: %w[read write webhook]

  # relations
  has_many :webhook_endpoints, class_name: 'Webhook::Endpoint'

  # callbacks
  before_create :generate_key

  # scopes
  scope :active, -> { where(active: true).where('expires_at IS NULL OR expires_at >= ?', Time.current) }
  scope :expired, -> { where.not(expires_at: nil).where('expires_at < ?', Time.current) }
  scope :permanent, -> { where(expires_at: nil) }

  def self.expire!
    expired.update_all(active: false)
  end

  def refresh!
    return unless expires_at.present?

    self.expires_at = EXPIRATION_TIME.since

    save!
  end

  def permanent?
    expires_at.nil?
  end

  protected

  def generate_key
    self.key = loop do
      random_key = SecureRandom.urlsafe_base64(64)
      break random_key unless Token.exists?(key: random_key)
    end
  end
end
