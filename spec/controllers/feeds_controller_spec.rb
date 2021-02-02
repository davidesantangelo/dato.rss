require 'rails_helper'

RSpec.describe FeedsController, type: :controller do
  describe 'GET #index' do
    before do
      get :index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end
end
