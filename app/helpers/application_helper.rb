module ApplicationHelper
  def count_record_index
    if params[:page].to_i > 1
      (params[:page].to_i - 1) * Kaminari.config.default_per_page.to_i
    else
      0
    end
  end
end
