require 'rails_helper'

RSpec.describe "GetOrganizations", type: :request do

  describe "get all organization route", :type => :request do
    let!(:organizations) { FactoryBot.create_list(:random_organization, 45) }

    it "renders a successful response" do
      get organizations_path
      expect(response).to be_successful
    end

    it 'returns all organizations' do
      get organizations_path
      # FactoryBot.create_list(:random_organization, 45)
      puts (response.body)

      expect(response.body.size).to eq(45)
    end
  end
end
