require 'rails_helper'

RSpec.feature 'user goes to organization page' do
  context 'delete organization data' do
    let!(:organization) { generate_organization_with_open_data(7) }

    scenario 'show organization info' do
      visit "/organizations/#{organization.id}"

      expect(page).to have_xpath('/html/body/div[2]/table/tbody/tr', :count => 7)
    end

    scenario 'press delete button' do
      visit "/organizations/#{organization.id}"

      find("a[href='#{organization_path(organization.id)}']").click

      expect(page).to have_current_path("/organizations/page/1")
      page.find('div', text: 'Запись удалена')
    end
  end

  context 'download organization open data' do
    let!(:organization) { generate_organization_with_open_data(7) }

    scenario 'press download button' do
      visit "/organizations/#{organization.id}"

      find("a[href='/download?id=#{organization.id}']").click

      date = Date.today.strftime('%Y-%m-%d')
      filename = "#{date}-#{organization.organization_id}.zip"

      expect(page.driver.response.headers['Content-Disposition']).to include "filename=\"#{filename}\""
      expect(page.driver.response.headers['Content-Type']).to include 'application/zip'
    end
  end
end
