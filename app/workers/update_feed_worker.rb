class UpdateFeedWorker
  include Sidekiq::Worker

  def perform(feed_id)
    feed = Feed.find(feed_id)

    feed.import!(from: Time.current)
  end
end
