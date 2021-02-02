set :output, 'log/schedule.log'

env :PATH, ENV['PATH']
env :RAILS_MASTER_KEY, ENV['RAILS_MASTER_KEY']

every 4.hours do
  rake 'importer:run'
end
