require 'rails_helper'

RSpec.describe 'serializers' do
  let!(:organization) { generate_organization_with_open_data(1) }
  let(:json) { ActiveModelSerializers::SerializableResource.new(organization, { serializer: OrganizationSerializer }).to_json }

  it 'serialize json' do
    parsed_json = JSON.parse(json)
    expect(parsed_json['title']).to eq organization.title
    expect(parsed_json['organization_tax_reference_number']).to eq organization.organization_id
    expect(parsed_json['open_data'][0]['title']).to eq OpenDatum.find_by(organization_id: organization.id).title
    expect(parsed_json['open_data'][0]['category']).to eq OpenDatum.find_by(organization_id: organization.id).category
    expect(parsed_json['open_data'][0]['identifier']).to eq OpenDatum.find_by(organization_id: organization.id).open_datum_id
  end
end
