class LogSerializer
  include JSONAPI::Serializer
  attributes :start_import_at, :end_import_at, :entries_count
  belongs_to :feed
end
