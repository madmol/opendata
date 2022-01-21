class OrganizationsController < ApplicationController
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

    @organization = Organization.find(get_organization_id_in_db)
  end

  def destroy
  end

  def get_organization_id_in_db
    params.permit(:id)[:id]
  end
end
