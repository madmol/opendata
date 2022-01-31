require 'rails_helper'

RSpec.describe 'OpenDatum' do
  before(:each) do
    Organization.create(
      id: 1, title: '1 organization', organization_id: '1234567890',
      created_at: Time.zone.now, updated_at: Time.zone.now
    )
  end

  let(:data) {
    [
      {
        organization_id: 1, title: 'open_datum 1', category: 'culture', open_datum_id: 'identifier 1',
        created_at: Time.zone.now, updated_at: Time.zone.now
      }
    ]
  }
  it 'save data from api to db' do
    expect { OpenDatum.save_api_data(data) }.to change { OpenDatum.count }.by(1)
  end

  it 'dont save empty data from api to db' do
    expect { OpenDatum.save_api_data([]) }.to change { OpenDatum.count }.by(0)
  end
end
