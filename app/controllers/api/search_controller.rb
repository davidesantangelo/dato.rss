module Api
  class SearchController < BaseController
    # callbacks
    before_action :check_params

    # /api/search/entries>
    def entries
      @pagy, @entries = pagy Entry.search(params[:q])

      json_response_with_serializer(@entries, Serializer::ENTRY)
    rescue StandardError => e
      Rails.logger.error(e)
      json_error_response('SearchEntriesError', e.message, 500)
    end

    # /api/search/feeds
    def feeds
      @pagy, @feeds = pagy Feed.search_full_text(params[:q])

      json_response_with_serializer(@feeds, Serializer::FEED)
    rescue StandardError => e
      Rails.logger.error(e)
      json_error_response('SearchFeedsError', e.message, 500)
    end

    private

    def permitted_params
      params.permit(:q)
    end

    def check_params
      json_error_response('Validation Failed', 'missing q param', :unprocessable_entity) unless permitted_params[:q].present?
    end
  end
end
