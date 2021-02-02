module Service
  class Metric
    API_URL = 'https://api.openrank.io/'.freeze

    def self.rank(domain)
      return 0 unless domain

      api(domain: domain).dig('data', domain, 'openrank').to_f
    end

    def self.api(domain:)
      response = RestClient::Request.execute(
        method: :get,
        url: "#{API_URL}?key=#{ENV['METRIC_KEY']}&d=#{domain}",
        timeout: 5
      )

      JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error e.response
      {}
    end
  end
end
