class FeedSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :url, :status, :entries_count, :last_import_at, :rank

  attribute :last_import_at do |object|
    object.last_import_at.present? ? object.last_import_at.to_i : nil
  end
end
