module OrganizationsHelper
  def link_to_open_data(organization)
    if organization.open_data.to_a.any?
      #if OpenDatum.find_by(organization_id: id)
      'Просмотреть данные'
    else
      'Получить данные'
    end
  end

  def set_download_button_class(organization)
    if organization.open_data.to_a.any?
      "btn btn-primary"
    else
      "btn btn-secondary disabled"
    end
  end
end
