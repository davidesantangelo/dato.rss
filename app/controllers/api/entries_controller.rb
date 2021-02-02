module Api
  class EntriesController < BaseController
    # callbacks
    before_action :set_feed
    before_action :set_feed_entry, only: %i[show tags]

    # GET /feeds/:id/entries.json
    def index
      @pagy, entries = pagy Entry.where(feed_id: params[:feed_id])

      json_response_with_serializer(entries, Serializer::ENTRY)
    end

    # GET /feeds/:id/entries/:id.json
    def show
      json_response_with_serializer(@entry, Serializer::ENTRY)
    end

    # GET /feeds/:id/entries/:id/tags.json
    def tags
      json_response_with_serializer(@entry, Serializer::TAG)
    end

    private

    def set_feed
      @feed = Feed.find(params[:feed_id])
    end

    def set_feed_entry
      @entry = @feed.entries.find_by!(id: params[:id]) if @feed
    end
  end
end
