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
      if api_data.get_organization_data.any?
        Organization.upsert_all(api_data.get_organization_data, unique_by: :index_organizations_on_title_and_organization_id)
      end
      unless api_data.status_code == 200
        flash.now[:alert] = 'Не удалось получить данные по API'
      end
    end

    @organizations = Organization.order(title: :asc).page(params[:page])
  end

  def show
    if @organization.open_data.to_a.empty?
      api_open_data = Api.call(@organization.organization_id)
      OpenDatum.upsert_all(api_open_data.get_open_data(@organization.id)) if api_open_data.get_open_data(@organization.id).any?

      unless api_open_data.status_code == 200
        flash.now[:alert] = 'Не удалось получить данные по API'
      end
    end

    @organization.reload

    if @organization.open_data.to_a.empty?
      flash.now[:notice] = 'Наборы открытых данных для данной организации отсутсвтвуют'
    end
  end

  def destroy
    deleted_org = @organization.destroy

    org_list = Organization.order(title: :asc).pluck(:title).to_a << deleted_org.title

    index = org_list.index(deleted_org.title) + 1

    total_pages = Organization.order(title: :asc).page.total_pages
    step = Organization.default_per_page

    page_int = index / step + 1

    page = if page_int < total_pages
             page_int
           else
             total_pages
           end
    # page < total_pages ? page : total_pages

    redirect_to organizations_path(page: page), notice: 'Запись удалена'
  end

  private

  def get_organization_id_in_db
    @organization = Organization.find(params.permit(:id)[:id])
  end
end
