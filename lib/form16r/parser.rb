require 'docsplit'

class Form16r::Parser
  attr_accessor :filename, :silent
  
  # This is the recommended way to call this class
  def self.parse(file: nil, silent: false)
    parser = self.new(file: file, silent: silent)
    parser.parse
  end
  
  def initialize(file: nil, silent: false)
    @filename = file ||
      (raise ArgumentError, "File argument must be given to parser")
    @silent = silent
  end

  def parse
    raise IOError, "File is not provided" unless filename
    text = convert_to_text
    log "Got #{text.length} characters to analyze."
    extractor = Form16r::Extractor.new(text: text)
    
    p extractor.extract_all
  end
  
  private
  def convert_to_text
    directory_name = File.absolute_path(File.dirname(filename))
    ext_name = File.extname(filename)
    base_name = File.basename(filename, ext_name)
    converted_text_path = File.join(directory_name, "#{base_name}.txt")
    
    if File.exists? converted_text_path
      log "Converted file already exists, skipping conversion"
    else
      log "Starting conversion to text..."
      Docsplit.extract_text(filename, :ocr => true, :output => directory_name)
      log "Done"
    end
    log "Reading text file at: #{converted_text_path}..."
    
    File.open(converted_text_path).read
  end
  
  def log(message)
    puts message unless silent
  end
end