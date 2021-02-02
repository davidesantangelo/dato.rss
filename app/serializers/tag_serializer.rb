class TagSerializer
  include JSONAPI::Serializer
  attributes :tags

  attribute :tags do |object|
    object.tags
  end
end
