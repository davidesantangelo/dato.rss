require 'pagy/extras/headers'

class ApplicationController < ActionController::Base
  include Pagy::Backend
end
