class Log < ApplicationRecord
  # relations
  belongs_to :feed, dependent: :destroy

  # validations
  validates :feed, presence: true

  def start!
    self.start_import_at = Time.current

    save!
  end

  def stop!(entries_count: nil)
    self.end_import_at = Time.current
    self.entries_count = entries_count

    save!

    feed.update_attribute(:last_import_at, Time.current)
  end
end
