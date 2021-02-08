class Feed < ApplicationRecord
  include W3CValidators
  include PgSearch::Model

  # FTS
  pg_search_scope :search_full_text, against: {
    title: 'A',
    description: 'B'
  }

  # scopes
  default_scope { order(entries_count: :desc) }
  scope :latest, -> { enabled.where('created_at >= ?', 24.hours.ago) }

  # relations
  has_many :entries, dependent: :destroy
  has_many :logs, dependent: :destroy
  has_many :webhook_endpoints, class_name: 'Webhook::Endpoint'

  # enums
  enum status: %i[enabled disabled]

  # validations
  validates :url, presence: true
  validates :title, presence: true
  validates_associated :entries

  # class methods
  def self.parse(url:)
    url = url.gsub('feed://', '').gsub('feed:', '').squish
    Feedjira.parse(RestClient.get(url).body)
  rescue Feedjira::NoParserAvailable => e
    Rails.logger.error(e)
    nil
  rescue URI::InvalidURIError => e
    Rails.logger.error(e)
    raise e
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error(e)
    raise e
  end

  def self.to_csv
    attributes = %w[url title description entries_count rank]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |feed|
        csv << attributes.map { |attr| feed.send(attr) }
      end
    end
  end

  def self.avg_rank
    all.average(:rank).to_f.round(2)
  end

  def self.recent(limit: 50)
    unscoped.latest.limit(limit)
  end

  def self.popular(limit: 20)
    unscoped.enabled.order(entries_count: :desc).limit(limit)
  end

  def self.add(url:)
    feed = parse(url: url)

    return false unless feed

    feed = find_or_create_by(url: url) do |f|
      f.title = feed.title.to_s.squish
      f.description = feed.description.to_s.squish
      f.image = feed.try(:image)
      f.language = feed.try(:language)
    end

    feed.enrich
    feed.async_import

    feed
  end

  def self.validate(url:)
    FeedValidator.new.validate_uri(url)
  end

  # instance methods
  def import!(from: nil)
    log = Log.create!(feed: self)

    log.start!

    count = 0

    Service::Parser.entries(url: url, from: from).each do |entry|
      created, entry = Entry.add(feed_id: id, entry: entry)
      if created
        count += 1
        entry.enrich
      end
    end

    log.stop!(entries_count: count)
  end

  def enrich
    domain_rank = Service::Metric.rank(domain).abs

    self.rank = domain_rank.zero? ? 0 : ((Math.log10(domain_rank) / Math.log10(100)) * 100).round

    save
  end

  def domain
    url = self.url.gsub('feed://', '').gsub('feed:', '').squish
    url = "http://#{url}" if URI.parse(url).scheme.nil?

    PublicSuffix.domain(URI.parse(url).host)
  rescue StandardError
    nil
  end

  def async_import
    ImportFeedWorker.perform_async(id)
  end

  def async_update
    UpdateFeedWorker.perform_async(id)
  end

  def language
    self[:language].to_s.split('-')[0]
  end
end
