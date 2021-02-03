class EntriesController < ApplicationController
  def index
    @pagy, @entries = pagy Entry.all
  end

  def search
    @pagy, @entries = pagy Entry.search_full_text(params[:q]).includes(:feed)
  end
end
