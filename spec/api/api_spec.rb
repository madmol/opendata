require 'rails_helper'

RSpec.describe 'API' do
  let(:organizations_list) { Api.call }

  it 'returns status 200 for organizations list' do
    expect(organizations_list.status_code).to eq 200
  end

  it 'returns correct organization data' do
    expect(organizations_list.convert_organization_data).to be_kind_of(Array)
    expect(organizations_list.convert_organization_data.sample).to have_key(:title)
    expect(organizations_list.convert_organization_data.sample).to have_key(:organization_id)
    expect(organizations_list.convert_organization_data.sample).to have_key(:created_at)
    expect(organizations_list.convert_organization_data.sample).to have_key(:updated_at)
  end


  context 'open data list' do
    let(:organization) { organizations_list.convert_organization_data.sample }
    # find reference tax number where open data exist
    let(:open_data_list) { Api.call(8601041920) }

    it 'returns status 200 for open data list' do
      expect(open_data_list.status_code).to eq 200
    end

    it 'returns correct open data' do
      Organization.insert(organization)
      expect(open_data_list.convert_open_data(Organization.last.id)).to be_kind_of(Array)
      expect(open_data_list.convert_open_data(Organization.last.id).sample).to have_key(:title)
      expect(open_data_list.convert_open_data(Organization.last.id).sample).to have_key(:organization_id)
      expect(open_data_list.convert_open_data(Organization.last.id).sample).to have_key(:category)
      expect(open_data_list.convert_open_data(Organization.last.id).sample).to have_key(:open_datum_id)
      expect(open_data_list.convert_open_data(Organization.last.id).sample).to have_key(:created_at)
      expect(open_data_list.convert_open_data(Organization.last.id).sample).to have_key(:updated_at)
    end
  end
end
