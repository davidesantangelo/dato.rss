# frozen_string_literal: true

namespace :importer do
  desc 'import feeds'
  task run: :environment do
    Token.expire!
    Service::Importer.run
  end
end
