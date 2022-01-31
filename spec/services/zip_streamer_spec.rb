require 'rails_helper'

RSpec.describe 'Stream zip' do
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
  let!(:file) { JsonSaver.call(json: json.to_json, org_reference_tax: json['organization_tax_reference_number']) }
  let(:zip_stream) { ZipStreamer.call(file_path: "tmp/#{file.file_name}.json") }


  it 'create zip stream' do
    file.save
    expect(zip_stream.create.class).to eq StringIO
    expect(zip_stream.create.closed?).to be false
    expect(zip_stream.create.pos).to eq 0
  end
end
