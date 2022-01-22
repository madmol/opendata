class OrganizationsController < ApplicationController

  def download
    make_json_file
    file_path = "tmp/#{file_name}.json"

    zip_stream = Zip::OutputStream.write_buffer do |zip|
      zip.put_next_entry(File.basename(file_path))
      zip.write(File.open(file_path, 'r').read)
    end
    # important - rewind the stream
    zip_stream.rewind

    send_data zip_stream.read,
              type: 'application/zip',
              disposition: 'attachment',
              filename: "#{file_name}.zip"
  end


  def index
    if Organization.none?
      organizations_data_from_api = Api.new.fetch_organizations_list_from_api
      Organization.save_data_from_api(organizations_data_from_api)
    end
    @organizations = Organization.all
  end

  def show
    unless OpenDatum.find_by(organization_id: get_organization_id_in_db)
      organization_tax_reference_number = Organization.find(get_organization_id_in_db).organization_id
      organization_open_data_from_api = Api.new.fetch_organization_open_data_from_api(organization_tax_reference_number)
      OpenDatum.save_data_from_api(organization_open_data_from_api, get_organization_id_in_db)
    end
    @open_data = OpenDatum.where(organization_id: get_organization_id_in_db)

    if @open_data.to_a.empty?
      flash.now[:notice] = 'Наборы открытых данных для данной организации отсутсвтвуют'
    end
    @json = OpenDatum.where(organization_id: get_organization_id_in_db)
              .select('open_datum_id AS identifier', :title, :category).to_json(:except => :id)


    @organization = Organization.find(get_organization_id_in_db)
  end

  def destroy
  end

  def get_organization_id_in_db
    params.permit(:id)[:id]
  end

  def make_json_file
    json = OpenDatum.create_json_structure(get_organization_id_in_db)

    json_file = File.new("tmp/#{file_name}.json", 'w')
    json_file << json
    json_file.close
  end

  def file_name
    date = Date.today.strftime("%Y-%m-%d")
    org_reference_tax = Organization.find(get_organization_id_in_db).organization_id
    "#{date}-#{org_reference_tax}"
  end
end
