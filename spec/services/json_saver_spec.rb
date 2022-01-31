require 'rails_helper'

RSpec.describe 'Save json to tmp folder' do
  let!(:json) {
    {
      'title' => 'Агентство инвестиционного развития Удмуртской Республики',
      'organization_tax_reference_number' => '1831171818',
      'open_data' => [{
        'title' => 'Сведения о подведомственной организации Агентства инвестиционного развития Удмуртской Республики',
        'category' => 'Economics',
        'identifier' => '1831171818-podved'
      }]
    }
  }
  let(:file) { JsonSaver.call(json: json.to_json, org_reference_tax: json['organization_tax_reference_number']) }

  it "initialize json" do
    expect(file.file_name).to eq "#{Date.today.strftime("%Y-%m-%d")}-#{json['organization_tax_reference_number']}"
  end

  it 'save json file in tmp folder' do
    file.save
    saved_file = File.open("tmp/#{file.file_name}.json")
    expect(JSON.parse(saved_file.read)).to eq json
  end

  it 'delete saved file from tmp foder' do
    file.save
    expect(File).to receive(:delete).with("tmp/#{file.file_name}.json")
    file.delete
  end
end