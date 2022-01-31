require 'rails_helper'

RSpec.feature 'user goes to main page' do

  context 'with organizations without loaded open_data' do
    let!(:organizations) { FactoryBot.create_list(:organization, Kaminari.config.default_per_page) }

    scenario 'and successfully visit organization' do
      visit '/'
      page.assert_selector('.breadcrumb-item', count: Kaminari.config.default_per_page)
      page.all('.breadcrumb-item').each do |el|
        expect(el.text).to eq 'Получить данные'
      end

      org_id = organizations[0].id
      find("a[href='#{organization_path(org_id)}']").click
      expect(page).to have_current_path("/organizations/#{org_id}")
      page.find('div', text: 'Наборы открытых данных для данной организации отсутствуют')

      expect(page).to have_selector(:css, '.btn-secondary')
    end
  end

  context 'with organizations with loaded open_data' do
    let!(:organization) { generate_organization_with_open_data(7) }

    scenario 'and successfully visit organization' do
      visit '/'
      page.assert_selector('.breadcrumb-item', count: 1)
      page.all('.breadcrumb-item').each do |el|
        expect(el.text).to eq 'Просмотреть данные'
      end

      org_id = organization.id
      find("a[href='#{organization_path(org_id)}']").click
      expect(page).to have_current_path("/organizations/#{org_id}")
    end
  end

  context 'and reload organizations list data' do
    let!(:organizations) { FactoryBot.create_list(:organization, Kaminari.config.default_per_page/2) }
    let(:organizations_to_add) { FactoryBot.create_list(:organization, Kaminari.config.default_per_page) }

    scenario 'and successfully reload organizations list' do
      visit '/'
      page.assert_selector('.breadcrumb-item', count: Kaminari.config.default_per_page/2)

      find("a[href='/reload']").click
      expect(page).to have_current_path('/organizations')
      page.find('div', text: 'Данные об организациях обновлены')
      page.assert_selector('.breadcrumb-item', count: Kaminari.config.default_per_page)
    end
  end
end
