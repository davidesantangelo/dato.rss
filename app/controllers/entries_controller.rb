class EntriesController < ApplicationController
  # constants
  EXPORT_ROW_LIMIT = 10_000

  # callabacks
  before_action :set_timing

  def index
    @pagy, @entries = pagy Entry.unscoped.latest

    respond_to do |format|
      format.html
      format.csv { send_data @entries.limit(EXPORT_ROW_LIMIT).to_csv, filename: "latest-entries-#{Date.today}.csv" }
    end
  end

  def search
    @pagy, @entries = pagy search_entries

    respond_to do |format|
      format.html
      format.csv { send_data search_entries.limit(EXPORT_ROW_LIMIT).to_csv, filename: "entries-#{Date.today}.csv" }
      format.rss { render layout: false }
    end
  end

  private

  def search_entries
    @search_entries ||= Entry.search(params[:q])
  end

  def set_timing
    @timing =
      if params[:q].present?
        Benchmark.measure { Entry.search(params[:q]) }
      else
        Benchmark.measure { Entry.unscoped.latest }
      end
  end
end
