class Form16r::Parser
  attr_accessor :data
  
  def initialize(data: nil, file: nil)
    @data = if file
      File.open(file).read
    elsif data
      data
    else
      raise ArgumentError, "Either file or data argument must be given to parser"
    end
  end
  
  def parse
    raise IOError, "Couldn't read data" unless data
    
    
  end
  
  def self.parse(data: nil, file: nil)
    parser = self.new(data, file)
    parser.parse
  end
end