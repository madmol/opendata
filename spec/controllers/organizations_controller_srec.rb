require 'rails_helper'

describe "get all organization route", :type => :request do
  let!(:organizations) { FactoryBot.create_list(:organization, 45) }

  # before {get '/organizations/'}

  expect(response).to have_http_status(:ok)

  describe "GET /index" do
    it "renders a successful response" do
      get articles_url
      expect(response).to be_successful
    end
  end


=begin
  it 'returns all organization' do
    expect(response).size).to eq(45)
    end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
=end
end
