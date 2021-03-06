class OrganizationsController < ApplicationController
  before_action :select_organization, only: %i[download show destroy]

  def download
    # checking that the user cannot download via URL
    if @organization.open_data.to_a.empty?
      redirect_to(organization_path(@organization)) && return
    end

    json = ActiveModelSerializers::SerializableResource.new(@organization, { serializer: OrganizationSerializer }).to_json

    file = JsonSaver.call(json: json, org_reference_tax: @organization.organization_id)
    file.save
    file_path = "tmp/#{file.file_name}.json"

    zip_stream = ZipStreamer.call(file_path: file_path).create
    file.delete

    send_data zip_stream.read,
              type: 'application/zip',
              disposition: 'attachment',
              filename: "#{file.file_name}.zip"
  end

  def index
    if Organization.none?
      data_from_api = Api.call

      Organization.save_api_data(data_from_api.convert_organization_data)

      unless data_from_api.status_code == 200
        flash.now[:alert] = 'Не удалось получить данные по API'
      end
    end

    @organizations = Organization.order(title: :asc).page(params[:page])
  end

  def show
    if @organization.open_data.to_a.empty?
      data_from_api = Api.call(@organization.organization_id)

      OpenDatum.save_api_data(data_from_api.convert_open_data(@organization.id))

      unless data_from_api.status_code == 200
        flash.now[:alert] = 'Не удалось получить данные по API'
      end
    end

    @organization.reload

    if @organization.open_data.to_a.empty?
      flash.now[:alert] = 'Наборы открытых данных для данной организации отсутствуют'
    end
  end

  def destroy
    page = select_page_number
    @organization.destroy
    redirect_to organizations_path(page: page), alert: 'Запись удалена'
  end

  def reload
    data_from_api = Api.call

    Organization.save_api_data(data_from_api.convert_organization_data)
    unless data_from_api.status_code == 200
      flash.now[:alert] = 'Не удалось получить данные по API'
    end
    redirect_to organizations_path, notice: 'Данные об организациях обновлены'
  end

  private
  # get current page from pagination
  def select_page_number
    index = Organization.order(title: :asc).pluck(:title).to_a.index(@organization.title)

    total_pages = Organization.order(title: :asc).page.total_pages
    item_per_page = Organization.default_per_page
    page_num = index/item_per_page + 1

    page_num < total_pages ? page_num : total_pages
  end

  def select_organization
    @organization = Organization.find(params.permit(:id)[:id])
  end
end
