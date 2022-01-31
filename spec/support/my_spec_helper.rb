module MySpecHelper
  def generate_organization_with_open_data(number)
    FactoryBot.create(:organization) do |organization|
      FactoryBot.create_list(:open_datum, number, organization: organization)
    end
  end
end

RSpec.configure do |c|
  c.include MySpecHelper
end
