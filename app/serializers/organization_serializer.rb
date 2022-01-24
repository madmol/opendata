class OrganizationSerializer < ActiveModel::Serializer
  attributes :title
  attribute :organization_id, key: :organization_tax_reference_number
  has_many :open_data
end
