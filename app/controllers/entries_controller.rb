class EntriesController < ApplicationController
  def index
    @pagy, @entries = pagy Entry.latest
  end

  def search
    @pagy, @entries = pagy total_entries
  end

  private

  def total_entries
    @total_entries ||= Entry.search(params[:q])
  end
end
