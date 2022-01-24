class JsonCreator
  def initialize(params)
    @path = params[:path]
    @class_name = params[:class_name]
    @method_name = params[:method_name]
    @id = params[:id]
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