class EntriesController < ApplicationController
  def search
    @pagy, @entries = pagy Entry.search_full_text(params[:q]).includes(:feed)
  end
end
