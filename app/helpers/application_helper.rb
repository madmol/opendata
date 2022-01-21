module ApplicationHelper
  def link_to_open_data(id)
    if OpenDatum.find_by(organization_id: id)
      'Просмотреть данные'
    else
      'Получить данные'
    end
  end
end
