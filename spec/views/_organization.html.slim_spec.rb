require 'rails_helper'

RSpec.describe 'organizations/_organization' do
  let!(:organizations) { FactoryBot.create_list(:organization, 45) }

  before(:each) do
    render partial: 'organizations/organization', collection: organizations
  end

  it 'show organizations' do
    expect(rendered).to match organizations.sample.title
    expect(rendered).to match organizations.sample.organization_id
  end

  it 'can view organization open data' do
    organization = organizations.sample
    expect(rendered).to have_link(link_to_open_data(organization), href: "/organizations/#{organization.id}")
  end
end
