module Api
  class FeedsController < BaseController
    # callbacks
    before_action :set_feed, only: [:show]
    before_action -> { check_token_authorization('write') }, only: [:create]
    before_action :check_create_params, only: [:create]

    # GET /feeds
    def index
      @pagy, feeds = pagy Feed.all

      json_response_with_serializer(feeds, Serializer::FEED)
    end

    # GET /feeds/:id
    def show
      json_response_with_serializer(@feed, Serializer::FEED)
    end

    # POST /feeds
    def create
      @feed = Feed.add(url: feed_params[:url])

      json_response_with_serializer(@feed, Serializer::FEED)
    rescue StandardError => e
      json_error_response('CreateFeedError', e.message, :internal_server_error)
    end

    # GET /feeds/popular
    def popular
      @feeds = Feed.popular

      json_response_with_serializer(@feeds, Serializer::FEED)
    end

    private

    def check_create_params
      return if feed_params[:url].present?

      json_error_response('Validation Failed', 'missing URL param', :unprocessable_entity)
    end

    def feed_params
      params.permit(:url)
    end

    def set_feed
      @feed = Feed.find(params[:id])
    end
  end
end
