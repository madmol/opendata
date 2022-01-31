require 'rails_helper'

RSpec.describe 'Get Organizations' do
  context 'main page' do
    it 'renders a successful response for /organizations' do
      get organizations_path
      expect(response).to be_successful
    end

    it 'renders a successful response for root_path' do
      get root_path
      expect(response).to be_successful
    end
  end
end
