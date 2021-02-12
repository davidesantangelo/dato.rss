class EntriesController < ApplicationController
  before_action :set_timing, only: [:search]

  def index
    @pagy, @entries = pagy Entry.latest
    respond_to do |format|
      format.html
      format.csv { send_data @entries.limit(10_000).to_csv, filename: "latest-entries-#{Date.today}.csv" }
    end
  end

  def search
    @pagy, @entries = pagy search_entries

    respond_to do |format|
      format.html
      format.csv { send_data search_entries.limit(10_000).to_csv, filename: "entries-#{Date.today}.csv" }
    end
  end

  private

  def search_entries
    @search_entries ||= Entry.search(params[:q])
  end

  def set_timing
    @timing ||= begin
      if params[:q].present?
        Benchmark.measure { Entry.search(params[:q]) }
      else
        Benchmark.measure { Entry.latest }
      end
    end
  end
end
