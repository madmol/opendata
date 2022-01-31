require 'rails_helper'

RSpec.describe 'Download .zip file' do
  let!(:organization) {
    FactoryBot.create(:organization) do |organization|
      FactoryBot.create_list(:open_datum, 7, organization: organization)
    end
  }

  it "generate zip" do
    get download_path(id: organization.id)
    expect(response.header['Content-Type']).to include 'application/zip'
    expect(response.header['Content-Disposition']).to include "#{Date.today.strftime("%Y-%m-%d")}-#{organization.organization_id}.zip"
  end
end
