class OrganizationsController < ApplicationController
  before_action :get_organization_id_in_db, only: %i[download show destroy]

  def download
    if @organization.open_data.to_a.empty?
      redirect_to organization_path(@organization) and return
    end

    json = ActiveModelSerializers::SerializableResource.new(@organization, {serializer: OrganizationSerializer}).to_json

    file = JsonSaver.call(json: json, org_reference_tax: @organization.organization_id)

    json_file_name = file.save_json_file
    file_path = "tmp/#{json_file_name}.json"

    zip_stream = ZipStreamer.call(file_path).create_zip_stream

    file.delete

    send_data zip_stream.read,
              type: 'application/zip',
              disposition: 'attachment',
              filename: "#{json_file_name}.zip"
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
    #unless OpenDatum.find_by(organization_id: @organization_id)
    if @organization.open_data.to_a.empty?
      #organization_tax_reference_number = Organization.find(@organization_id).organization_id
      #organization_tax_reference_number = @organization.organization_id
      #api_open_data = Api.call(organization_tax_reference_number)
      api_open_data = Api.call(@organization.organization_id)
      OpenDatum.upsert_all(api_open_data.get_open_data(@organization.id)) if api_open_data.get_open_data(@organization.id).any?
      # OpenDatum.save_data_from_api(api_organization_open_data.json, get_organization_id_in_db)

      #if OpenDatum.where(organization_id: @organization_id).to_a.empty?


      unless api_open_data.status_code == 200
        flash.now[:alert] = 'Не удалось получить данные по API'
      end
    end
    # @open_data = @organization.open_data

    @organization.reload

    if @organization.open_data.to_a.empty?
      flash.now[:notice] = 'Наборы открытых данных для данной организации отсутсвтвуют'
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_path, notice: 'Запись удалена'
  end

  private

  def get_organization_id_in_db
    @organization = Organization.find(params.permit(:id)[:id])
  end
end
