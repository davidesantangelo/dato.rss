class FeedsController < ApplicationController
  before_action :set_feed, only: [:entries]

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
        @pagy, @entries = pagy @feed.entries
      end
      format.csv do
        send_data @feed.entries.limit(10_000).to_csv, filename: "feed-#{@feed.title}-entries-#{Date.today}.csv"
      end
    end
  end

  private

  def set_feed
    @feed = Feed.find(params[:id])
  end
end
