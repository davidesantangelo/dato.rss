class WebhookSerializer
  include JSONAPI::Serializer
  attributes :url, :events, :created_at, :updated_at

  attribute :created_at do |object|
    object.created_at.to_i
  end

  attribute :updated_at do |object|
    object.updated_at.to_i
  end
end
