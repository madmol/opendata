class JsonSaver
  attr_reader :file_name

  def self.call(params)
    new(params)
  end

  def initialize(params)
    @json = params[:json]
    @org_reference_tax = params[:org_reference_tax]
    date = Date.today.strftime("%Y-%m-%d")
    @file_name = "#{date}-#{@org_reference_tax}"
  end

  def save
    json_file = File.new("tmp/#{@file_name}.json", 'w')
    json_file << @json
    json_file.close
  end

  def delete
    File.delete("tmp/#{@file_name}.json")
  end
end
