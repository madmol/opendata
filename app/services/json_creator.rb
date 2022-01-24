class JsonCreator
  def initialize(params)
    @path = params[:path]
    @class_name = params[:class_name]
    @method_name = params[:method_name]
    @id = params[:id]
  end



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

  def make_open_data_json_file(id)
    json = OpenDatum.create_open_data_json_structure(id)

    json_file = File.new("tmp/#{file_name}.json", 'w')
    json_file << json
    json_file.close
  end

  private

  def file_name(id)
    date = Date.today.strftime("%Y-%m-%d")
    org_reference_tax = Organization.find(id).organization_id
    "#{date}-#{org_reference_tax}"
  end
end
