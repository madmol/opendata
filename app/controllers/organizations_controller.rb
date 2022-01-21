class OrganizationsController < ApplicationController
  def index
    Organization.save_data_from_api if Organization.none?
    @organizations = Organization.all
  end

  def show
    OpenDatum.save_data_from_api(organization_params) unless OpenDatum.find_by(organization_id: organization_params)
    @open_data = OpenDatum.where(organization_id: organization_params)
    @organization = Organization.find(organization_params)
  end

  def destroy
  end

  def organization_params
    params.permit(:id)[:id]
  end
end
