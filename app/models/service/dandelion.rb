module Service
  class Dandelion
    API_URL = 'https://api.dandelion.eu/'.freeze

    def self.annotations(text:)
      payload = {
        text: text,
        token: ENV['DANDELION_TOKEN'],
        include: 'types,categories',
        top_entities: 5
      }

      response = api(action: 'nex', payload: payload)
      response.fetch('annotations', nil)
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error e.response
      nil
    end

    def self.sentiment(text:)
      payload = {
        text: text,
        token: ENV['DANDELION_TOKEN']
      }

      response = api(action: 'sent', payload: payload)
      response.fetch('sentiment', nil)
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error e.response
      nil
    end

    def self.api(action:, payload: {})
      response = RestClient::Request.execute(
        method: :post,
        url: "#{API_URL}datatxt/#{action}/v1/?",
        payload: payload,
        timeout: 10
      )

      JSON.parse(response.body)
    end
  end
end
