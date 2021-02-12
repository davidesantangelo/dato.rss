class FeedsController < ApplicationController
  before_action :set_feed, only: [:entries]
  before_action :set_timing, only: [:entries]

  def index
    @pagy, @feeds = pagy Feed.all

    respond_to do |format|
      format.html
      format.csv { send_data @feeds.to_csv, filename: "feeds-#{Date.today}.csv" }
    end
  end

  def entries
    respond_to do |format|
      format.html do
        @pagy, @entries = pagy feed_entries
      end
      format.csv do
        send_data feed_entries.limit(10_000).to_csv, filename: "feed-#{@feed.title}-entries-#{Date.today}.csv"
      end
    end
  end

  private

  def set_feed
    @feed = Feed.find(params[:id])
  end

  def feed_entries
    @feed_entries ||= begin
      if params[:q].present?
        Entry.where(feed_id: @feed.id).search(params[:q])
      else
        Entry.where(feed_id: @feed.id)
      end
    end
  end

  def set_timing
    @timing = Benchmark.measure { Entry.where(feed_id: @feed.id).search(params[:q]) }
  end
end
