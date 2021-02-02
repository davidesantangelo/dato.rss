module Webhook
  module Observable
    extend ActiveSupport::Concern
    include Webhook::Delivery

    included do
      after_commit on: :create do
        deliver_webhook(:created)
      end

      after_commit on: :update do
        deliver_webhook(:updated)
      end

      after_commit on: :destroy do
        deliver_webhook(:destroyed)
      end
    end
  end
end
