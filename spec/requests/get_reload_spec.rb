require 'rails_helper'

RSpec.describe 'Reload organizations data' do
  it 'reload organizations data' do
    get reload_path
    expect(response).to redirect_to '/organizations'
  end
end
