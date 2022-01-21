class Api
  URL = 'https://data.gov.ru/'

  def fetch_organizations_list_from_api
    response = Faraday.get(make_api_link(URL))

    JSON.parse(response.body) if response.status == 200
  end

  def fetch_organization_open_data_from_api(organization_tax_reference)
    response = Faraday.get(make_api_link(URL, organization_tax_reference))

    JSON.parse(response.body) if response.status == 200
  end

  private

  def make_api_link(url, organization_tax_reference = '')
    if organization_tax_reference == ''
      "#{url}api/json/organization/?access_token=#{ENV['API_KEY_OPENDATA_GOV']}"
    else
      "#{url}api/json/organization/#{organization_tax_reference}/dataset/?access_token=#{ENV['API_KEY_OPENDATA_GOV']}"
    end
  end
end
