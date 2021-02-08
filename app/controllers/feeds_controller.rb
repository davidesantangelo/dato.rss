class FeedsController < ApplicationController
  before_action :reset_params_q

  def index
    @pagy, @feeds = pagy Feed.all

    respond_to do |format|
      format.html
      format.csv { send_data @feeds.to_csv, filename: "feeds-#{Date.today}.csv" }
    end
  end

  private

  def reset_params_q
    params[:q] = nil
  end
end
