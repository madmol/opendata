class ZipStreamer
  def self.call(file_path)
    new(file_path)
  end

  def initialize(file_path)
    @file_path = file_path
  end

  def create_zip_stream
    zip_stream = Zip::OutputStream.write_buffer do |zip|
      zip.put_next_entry(File.basename(@file_path))
      zip.write(File.open(@file_path, 'r').read)
    end
    # important - rewind the stream
    zip_stream.rewind
    zip_stream
  end
end
