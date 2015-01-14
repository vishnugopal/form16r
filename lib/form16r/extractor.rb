class Form16r::Extractor
  attr_accessor :text
  
  def initialize(text: text)
    @text = text
  end
  
  def extract_all
    {
      certificate_number: certificate_number,
      last_updated_on: last_updated_on
    }
  end
  
  def certificate_number
    text.match(/for tax deducted at source on salary(.*?)No. ([A-Z]{7,7})/m)[2]
  end
  
  def last_updated_on
    text.match(/Last updated(.*?)([0-9]{2,2}-[A-Za-z]{3,3}-[0-9]{4,4})/m)[2]
  end
end