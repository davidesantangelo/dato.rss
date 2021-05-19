module Api
  class WebhooksController < BaseController
    # callbacks
    before_action -> { check_token_authorization('write') }, only: [:create]
    before_action :check_create_params, only: [:create]

    # GET /:id/webhooks
    def index
      @pagy, webhooks = pagy token_webhook_callbacks

      json_response_with_serializer(webhooks, Serializer::WEBHOOK)
    end

    # GET /:id/webhooks/:id
    def show
      json_response_with_serializer(@webhook, Serializer::WEBHOOK)
    end

    # POST /:id/webhooks
    def create
      @webhook = token_webhook_callbacks.create!(webhook_params)

      json_response_with_serializer(@webhook, Serializer::WEBHOOK)
    end

    # PATCH/PUT /:id/webhooks/:id
    def update
      @webhook = token_webhook_callbacks.update(webhook_params)

      json_response_with_serializer(@webhook, Serializer::WEBHOOK)
    end

    # DELETE /:id/webhooks
    def destroy
      @webhook.destroy

      head :no_content
    end

    private

    def check_create_params
      unless webhook_params[:url].present?
        json_error_response('Validation Failed', 'missing URL param', :unprocessable_entity)
        return
      end

      return if webhook_params[:events].present?

      json_error_response('Validation Failed', "missing events param (#{Webhook::Event::EVENT_TYPES.join(',')})", :unprocessable_entity)
    end

    def token_webhook_callbacks
      current_token.callbacks
    end

    def webhook_params
      params.permit(:url, events: [])
    end
  end
end