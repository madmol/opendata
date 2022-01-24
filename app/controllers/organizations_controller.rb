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
      api_data = Api.call
      Organization.upsert_all(api_data.get_organization_data) if api_data.get_organization_data.any?
      if api_data.status_code != 200
        flash.now[:alert] = 'Не удалось получить данные по API'
      end
    end

    @organizations = Organization.all
  end

  def show
    org_id = get_organization_id_in_db
    unless OpenDatum.find_by(organization_id: org_id)
      organization_tax_reference_number = Organization.find(org_id).organization_id
      api_open_data = Api.call(organization_tax_reference_number)
      OpenDatum.upsert_all(api_open_data.get_open_data(org_id)) if api_open_data.get_open_data(org_id).any?
      #OpenDatum.save_data_from_api(api_organization_open_data.json, get_organization_id_in_db)

      if api_open_data.status_code != 200
        flash.now[:alert] = 'Не удалось получить данные по API'
      end
    end
    @open_data = OpenDatum.where(organization_id: org_id)

    if @open_data.to_a.empty?
      flash.now[:notice] = 'Наборы открытых данных для данной организации отсутсвтвуют'
    end

    @organization = Organization.find(org_id)
  end

  def destroy
  end

  private

  def get_organization_id_in_db
    params.permit(:id)[:id]
  end

=begin
  def make_json_file
    json = OpenDatum.create_open_data_json_structure(get_organization_id_in_db)

    json_file = File.new("tmp/#{file_name}.json", 'w')
    json_file << json
    json_file.close
  end

  def file_name
    date = Date.today.strftime("%Y-%m-%d")
    org_reference_tax = Organization.find(get_organization_id_in_db).organization_id
    "#{date}-#{org_reference_tax}"
  end
=end
end
