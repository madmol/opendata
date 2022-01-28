require 'rails_helper'

RSpec.describe 'Delete Organization' do
  let!(:organization) {
      FactoryBot.create(:organization) do |organization|
        FactoryBot.create_list(:open_datum, 7, organization: organization)
      end
  }

  it 'redirect to index' do
    delete organization_path(organization)
    expect(response).to redirect_to("#{organizations_path}/page/1")
  end

  it 'delete organization' do
    expect {
      delete organization_path(organization)
    }.to change(Organization, :count).by(-1)
  end

  it 'delete associated open_data' do
    expect {
      delete organization_path(organization)
    }.to change(OpenDatum, :count).by(-7)
  end
end
