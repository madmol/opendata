class ZipStreamer
  def self.call(params)
    new(params)
  end

  def initialize(params)
    @file_path = params[:file_path]
  end

  def create
    zip_stream = Zip::OutputStream.write_buffer do |zip|
      zip.put_next_entry(File.basename(@file_path))
      zip.write(File.open(@file_path, 'r').read)
    end
    # important - rewind the stream
    zip_stream.rewind
    zip_stream
  end
end
