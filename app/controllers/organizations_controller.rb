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
      api_status = Organization.call_api
      unless api_status == 200
        flash.now[:alert] = 'Не удалось получить данные по API'
      end
    end

    @organizations = Organization.order(title: :asc).page(params[:page])
  end

  def show
    if @organization.open_data.to_a.empty?
      api_status = OpenDatum.call_api(@organization.organization_id, @organization.id)
      unless api_status == 200
        flash.now[:alert] = 'Не удалось получить данные по API'
      end
    end

    @organization.reload

    if @organization.open_data.to_a.empty?
      flash.now[:notice] = 'Наборы открытых данных для данной организации отсутсвтвуют'
    end
  end

  def destroy
    page = get_page_number
    @organization.destroy
    redirect_to organizations_path(page: page), notice: 'Запись удалена'
  end

  def reload
    params.permit(:reload)[:reload]
    redirect_to organizations_path, notice: 'Данные об организациях обновлены'
  end

  private
  # get current page from pagination
  def get_page_number
    index = Organization.order(title: :asc).pluck(:title).to_a.index(@organization.title)

    total_pages = Organization.order(title: :asc).page.total_pages
    item_per_page = Organization.default_per_page
    page_num = index / item_per_page + 1

    page_num < total_pages ? page_num : total_pages
  end

  def get_organization_id_in_db
    @organization = Organization.find(params.permit(:id)[:id])
  end
end
