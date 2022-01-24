class JsonSaver
  attr_reader :file_name

  def self.call(params)
    new(params)
  end

  def initialize(params)
    @json = params[:json]
    @org_reference_tax = params[:org_reference_tax]
  end

  def save_json_file
    json_file = File.new("tmp/#{file_name}.json", 'w')
    json_file << @json
    json_file.close
    file_name
  end

  def delete
    File.delete("tmp/#{file_name}.json")
  end

  private

  def file_name
    date = Date.today.strftime("%Y-%m-%d")
    "#{date}-#{@org_reference_tax}"
  end
end
