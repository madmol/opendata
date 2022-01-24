class OrganizationsController < ApplicationController
  before_action :get_organization_id_in_db, only: %i[download show destroy]
  before_action :require_organization_data, only: :download

  def download
    organization = Organization.find(@organization_id)

    json = ActiveModelSerializers::SerializableResource.new(organization, {serializer: OrganizationSerializer}).to_json

    make_json_file(json)

    file_path = "tmp/#{file_name}.json"

    zip_stream = ZipStreamer.call(file_path).create_zip_stream

    send_data zip_stream.read,
              type: 'application/zip',
              disposition: 'attachment',
              filename: "#{file_name}.zip"
  end

  def index
    if Organization.none?
      api_data = Api.call
      Organization.upsert_all(api_data.get_organization_data) if api_data.get_organization_data.any?
      unless api_data.status_code == 200
        flash.now[:alert] = 'Не удалось получить данные по API'
      end
    end

    @organizations = Organization.all
  end

  def show
    unless OpenDatum.find_by(organization_id: @organization_id)
      organization_tax_reference_number = Organization.find(@organization_id).organization_id
      api_open_data = Api.call(organization_tax_reference_number)
      OpenDatum.upsert_all(api_open_data.get_open_data(@organization_id)) if api_open_data.get_open_data(@organization_id).any?
      #OpenDatum.save_data_from_api(api_organization_open_data.json, get_organization_id_in_db)

      if OpenDatum.where(organization_id: @organization_id).to_a.empty?
        flash.now[:notice] = 'Наборы открытых данных для данной организации отсутсвтвуют'
      end

      unless api_open_data.status_code == 200
        flash.now[:alert] = 'Не удалось получить данные по API'
      end
    end
    @open_data = OpenDatum.where(organization_id: @organization_id)

    @organization = Organization.find(@organization_id)
  end

  def destroy
  end

  private

  def require_organization_data
    if OpenDatum.where(organization_id: @organization_id).to_a.empty?
      flash.now[:notice] = 'Наборы открытых данных для данной организации отсутсвтвуют'
      redirect_to organization_path(Organization.find(@organization_id))
    end
  end

  def get_organization_id_in_db
    @organization_id = params.permit(:id)[:id]
  end

  def make_json_file(json)
    json_file = File.new("tmp/#{file_name}.json", 'w')
    json_file << json
    json_file.close
  end

  def file_name
    date = Date.today.strftime("%Y-%m-%d")
    org_reference_tax = Organization.find(@organization_id).organization_id
    "#{date}-#{org_reference_tax}"
  end
end
