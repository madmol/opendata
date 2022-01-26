module OrganizationsHelper
  def link_to_open_data(organization)
    if organization.open_data.to_a.any?
      'Просмотреть данные'
    else
      'Получить данные'
    end
  end

  def select_download_button_class(organization)
    if organization.open_data.to_a.any?
      'btn btn-primary'
    else
      'btn btn-secondary disabled'
    end
  end
end
