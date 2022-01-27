require 'rails_helper'

RSpec.describe "OpenData", type: :request do
  describe "GET /open_data" do
    it "works! (now write some real specs)" do
      get open_data_path
      expect(response).to have_http_status(200)
    end
  end
end
