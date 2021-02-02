class TokenSerializer
  include JSONAPI::Serializer
  attributes :key, :expires_at, :active, :permissions

  attribute :expires_at do |object|
    object.expires_at.to_i
  end
end
