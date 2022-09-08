module Service
  class Importer
    def self.run(limit: 250)
      Feed.unscoped.all.order('last_import_at ASC NULLS FIRST').limit(limit).find_each(&:async_update)
    end

    def self.reload(feed:)
      feed.entries.delete_all
      feed.logs.delete_all
      feed.async_import
    end
  end
end
