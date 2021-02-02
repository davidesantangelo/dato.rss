class EntrySerializer
  include JSONAPI::Serializer
  belongs_to :feed
  attributes :title, :url, :published_at, :body, :text, :categories, :sentiment, :parent

  attribute :text do |object|
    object.text
  end

  attribute :tags do |object|
    object.tags
  end

  attribute :parent do |object|
    {
      id: object.feed.id,
      title: object.feed.title,
      url: object.feed.url,
      rank: object.feed.rank
    }
  end

  attribute :published_at do |object|
    object.published_at.to_i
  end
end
