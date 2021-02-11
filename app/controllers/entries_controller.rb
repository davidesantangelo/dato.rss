class EntriesController < ApplicationController
  def index
    @pagy, @entries = pagy Entry.latest
    @timing = Benchmark.measure { Entry.latest }

    respond_to do |format|
      format.html
      format.csv { send_data @entries.limit(10_000).to_csv, filename: "latest-entries-#{Date.today}.csv" }
    end
  end

  def search
    @pagy, @entries = pagy total_entries

    respond_to do |format|
      format.html
      format.csv { send_data total_entries.limit(10_000).to_csv, filename: "entries-#{Date.today}.csv" }
    end
  end

  private

  def total_entries
    @timing = Benchmark.measure { Entry.search(params[:q]) }
    @total_entries ||= Entry.search(params[:q])
  end
end
