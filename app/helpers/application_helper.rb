module ApplicationHelper
  def count_record_index
    if params[:page].to_i > 1
      (params[:page].to_i - 1) * Kaminari.config.default_per_page
    else
      0
    end
  end

  def choose_flash_type(type)
    if type == 'notice'
      'info'
    elsif type == 'alert'
      'danger'
    end
  end
end
