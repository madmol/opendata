require 'rails_helper'

RSpec.describe 'Delete Organization' do
  let!(:organization) { generate_organization_with_open_data(7) }

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
