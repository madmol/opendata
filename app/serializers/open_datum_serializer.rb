class OpenDatumSerializer < ActiveModel::Serializer
  attributes :title, :category
  attribute :open_datum_id, key: :identifier
  belongs_to :organization

=begin
  def self.create_open_data_json_structure(organization_id)
    OpenDatum.where(organization_id: organization_id)
        .select('open_datum_id AS identifier', :title, :category).to_a.map do |record|
      # add organization info to json file and delete :id
      organization_data_hash = {
          :organization_tax_reference => Organization.find(organization_id).organization_id,
          :organization_title => Organization.find(organization_id).title
      }
      record.serializable_hash.merge!(organization_data_hash).except('id')
    end.to_json
  end
=end
end
