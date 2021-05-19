module Webhook
  class Callback < ApplicationRecord
    # utilities
    attribute :events, :string, array: true, default: []

    # relations
    belongs_to :token

    # validations
    validates :url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
    validates :events, presence: true
    validates :url, uniqueness: { scope: :token }

    def self.for_event(events)
      where('events @> ARRAY[?]::varchar[]', Array(events))
    end

    def events=(events)
      events = Array(events).map { |event| event.to_s.underscore }
      super(Webhook::Event::EVENT_TYPES & events)
    end

    def deliver(event)
      Webhook::DeliveryWorker.perform_async(id, event.to_json)
    end
  end
end
