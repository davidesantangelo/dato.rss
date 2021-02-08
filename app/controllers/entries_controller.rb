class EntriesController < ApplicationController
  def index
    @pagy, @entries = pagy Entry.latest
  end

  def search
    @pagy, @entries = pagy total_entries

    respond_to do |format|
      format.html
      format.csv { send_data total_entries.to_csv, filename: "entries-#{Date.today}.csv" }
    end
  end

  private

  def total_entries
    @total_entries ||= Entry.search(params[:q])
  end
end
