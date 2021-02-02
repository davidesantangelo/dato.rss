class FeedsController < ApplicationController
  before_action :reset_params_q

  def index
    @pagy, @feeds = pagy Feed.all
  end

  private

  def reset_params_q
    params[:q] = nil
  end
end
