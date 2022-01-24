class Api
  attr_reader :status_code

  URL = 'https://data.gov.ru/'

  class << self
    def call(organization_tax_reference = '')
      response = Faraday.get(make_api_link(URL, organization_tax_reference))

      if response.status == 200
        json = JSON.parse(response.body)
        status_code = response.status
      else
        status_code = response.status
        json = ''
      end

      new(status: status_code, json: json)
    end

    private

    def make_api_link(url, organization_tax_reference)
      if organization_tax_reference == ''
        "#{url}api/json/organization/?access_token=#{ENV['API_KEY_OPENDATA_GOV']}"
      else
        "#{url}api/json/organization/#{organization_tax_reference}/dataset/?access_token=#{ENV['API_KEY_OPENDATA_GOV']}"
      end
    end
  end

  def initialize(params)
    @status_code = params[:status]
    @json = params[:json]
  end

  def get_organization_data
    @json.uniq{ |org| org['id'] }.select{ |org| org['id'].length == 10 && /\d/ =~ org['id'] }.map do |organization|
      {
        title: organization['title'],
        organization_id: organization['id'],
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    end
  end

  def get_open_data(org_id)
    @json.select{ |od| od['title'].present? }.map do |open_data|
      {
        organization_id: org_id,
        title: open_data['title'],
        category: open_data['topic'],
        open_datum_id: open_data['identifier'],
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    end
  end
end
