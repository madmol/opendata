require 'rails_helper'

RSpec.describe Organization, type: :model do
  let(:data) {
    [
      {
        title: 'organization 1',
        organization_id: '1234567890',
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    ]
  }
  it 'save data from api to db' do
    expect { Organization.save_api_data(data) }.to change { Organization.count }.by(1)
  end

  it 'dont save empty data from api to db' do
    expect { Organization.save_api_data([]) }.to change { Organization.count }.by(0)
  end
end
