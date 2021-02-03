class Entry < ApplicationRecord
  include Webhook::Observable
  include ActionView::Helpers::SanitizeHelper
  include PgSearch::Model

  # FTS
  pg_search_scope :search_full_text, against: {
    title: 'A',
    body: 'B',
    url: 'C'
  }, using: {
    tsearch: {
      prefix: true,
      tsvector_column: 'searchable',
      highlight: {
        StartSel: '<b>',
        StopSel: '</b>',
        MaxWords: 123,
        MinWords: 456,
        ShortWord: 4,
        HighlightAll: true,
        MaxFragments: 3,
        FragmentDelimiter: '&hellip;'
      }
    }
  }

  # scopes
  default_scope { order(created_at: :desc) }

  scope :enriched, -> { where.not(enriched_at: nil) }
  scope :newest, -> { where('created_at <= ?', 24.hours.ago) }

  # relations
  belongs_to :feed, counter_cache: true

  # validations
  validates :url, presence: true
  validates :title, presence: true
  validates_uniqueness_of :url

  # class methods
  def self.add(feed_id:, entry:)
    return [false, nil] if find_by(url: entry.url)

    attrs = {
      feed_id: feed_id,
      title: entry.title.blank? ? 'untitled' : entry.title,
      body: entry.summary,
      url: entry.url,
      external_id: entry.entry_id,
      categories: entry&.categories.to_a.map(&:downcase),
      published_at: entry.published || Time.current
    }

    entry = create!(attrs)

    [true, entry]
  rescue ActiveRecord::RecordNotUnique
    [false, nil]
  end

  def self.search(query)
    search_full_text(query).includes(:feed)
  end

  # instance methods
  def as_indexed_json(_options = {})
    as_json(except: ['annotations'])
  end

  def body
    self[:body].presence || 'no content'
  end

  def tags
    return [] unless annotations.present?

    annotations.uniq { |h| h['id'] }.map do |annotation|
      {
        uri: annotation.dig('uri'),
        spot: annotation.dig('spot'),
        label: annotation.dig('label'),
        confidence: annotation.dig('confidence'),
        categories: annotation.dig('categories')
      }
    end
  end

  def text
    return title unless body.present?

    strip_tags(body).to_s.squish
  end

  def enrich
    annotations = get_annotations
    sentiment = get_sentiment

    self.annotations = annotations
    self.sentiment = sentiment
    self.enriched_at = Time.current

    save!
  end

  private

  def webhook_scope
    feed
  end

  def webhook_payload
    { entry: self }
  end

  def get_annotations
    Service::Dandelion.annotations(text: text)
  end

  def get_sentiment
    Service::Dandelion.sentiment(text: text)
  end
end
