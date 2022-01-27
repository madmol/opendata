class Organization < ApplicationRecord
  has_many :open_data, dependent: :destroy

  # validates :organization_id, :title, presence: true
  # use upsert_all instead creating instance and then saving it
  #validates :organization_id, uniqueness: true, length: { is: 10 }, format: { with: /\d/ }
=begin
  def self.call_api
    api_data = Api.call
    if api_data.json.any?
      Organization.upsert_all(api_data.convert_organization_data, unique_by: :index_organizations_on_title_and_organization_id)
    end
    api_data.status_code
  end
=end
  def self.save_api_data(data)
    if data.any?
      Organization.upsert_all(data, unique_by: :index_organizations_on_title_and_organization_id)
    end
  end
end
