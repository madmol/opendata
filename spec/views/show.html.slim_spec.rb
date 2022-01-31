require 'rails_helper'

RSpec.describe 'show organization info' do
  let!(:organization) {
    FactoryBot.create(:organization) do |organization|
      FactoryBot.create_list(:open_datum, 7, organization: organization)
    end
  }
  before(:each) do
    assign(:organization, organization)
    render :template => 'organizations/show', :layout => 'layouts/application'
  end

  it 'can download organization open_data' do
    expect(rendered).to have_link('Экспортировать данные', href: "/download?id=#{organization.id}")
  end

  it 'can delete organization and open_data' do
    expect(rendered).to have_link('Удалить организацию', href: "/organizations/#{organization.id}")
  end

  it 'have correct organization data' do
    expect(rendered).to match "#{organization.organization_id}"
    expect(rendered).to match "#{organization.title}"
  end
end
