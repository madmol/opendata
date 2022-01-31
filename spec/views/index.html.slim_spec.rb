require 'rails_helper'

RSpec.describe 'organizations' do
  let!(:organizations) { FactoryBot.create_list(:organization, 45) }
  before(:each) do
    assign(:organizations, organizations)
    view.stub(:paginate)
    render :template => 'organizations/index', :layout => 'layouts/application'
  end

  it 'can update organizations list' do
    expect(rendered).to have_link('Обновить данные', href: '/reload')
  end
end
