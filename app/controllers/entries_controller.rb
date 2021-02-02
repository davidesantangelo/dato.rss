class EntriesController < ApplicationController
  def index
    @pagy, @entries = pagy Entry.all
  end

  def search
    @pagy, @entries = pagy total_entries
  end

  private

  def total_entries
    @total_entries ||= Entry.search_full_text(params[:q]).includes(:feed)
  end
end
