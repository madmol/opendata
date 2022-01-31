require 'rails_helper'

RSpec.describe "Get Organization" do
  let!(:open_data) { FactoryBot.create_list(:open_datum, 15) }

  context 'show organization info' do
    it 'renders a successful response for organization open data' do
      get organization_path(open_data.sample.organization_id)
      expect(response).to be_successful
    end
  end
end
