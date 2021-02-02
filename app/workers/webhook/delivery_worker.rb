require 'net/http'

module Webhook
  class DeliveryWorker
    include Sidekiq::Worker

    def perform(endpoint_id, payload)
      return unless endpoint == Webhook::Endpoint.find(endpoint_id)

      response = request(endpoint.url, payload)

      case response.code
      when 410
        endpoint.destroy
      when 400..599
        raise response.to_s
      end
    end

    private

    def request(endpoint, payload)
      uri = URI.parse(endpoint)

      RestClient::Request.execute(
        method: :post,
        url: uri.to_s,
        payload: payload.to_json,
        headers: { content_type: :json, accept: :json },
        verify_ssl: uri.scheme == 'https',
        timeout: 3
      )
    end
  end
end
