require 'rails_helper'

RSpec.describe OpenDatum, type: :model do
  it 'save big amount of data to db' do
    expect {
      OpenDatum.save_api_data(name: "John", login: "john")
    }.to change{User.count}.by(1)
  end

end
