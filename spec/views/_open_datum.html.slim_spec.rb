require 'rails_helper'

RSpec.describe 'open_data/_open_data' do
  let!(:organization) {
    FactoryBot.create(:organization) do |organization|
      FactoryBot.create_list(:open_datum, 7, organization: organization, category: 'Economics')
    end
  }

  before(:each) do
    render partial: 'open_data/open_datum', collection: organization.open_data
  end

  it 'show open_data' do
    expect(rendered).to match organization.open_data.sample.title
    expect(rendered).to match organization.open_data.sample.open_datum_id
    expect(rendered).to match organization.open_data.sample.translate_category
  end
end
