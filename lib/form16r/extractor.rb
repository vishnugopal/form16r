class Form16r::Extractor
  attr_accessor :text
  
  def initialize(text: text)
    @text = text
  end
  
  def extract_all
    {
      part_a: {
        certificate_number: certificate_number,
        last_updated_on: last_updated_on,
        employer_address: employer_address,
        employee_address: employee_address,
        pan_deductor: pan_deductor,
        tan_deductor: tan_deductor,
        pan_employee: pan_employee,
        employee_reference_number: employee_reference_number,
        assessment_year: assessment_year,
        period_with_employer_from: period_with_employer_from,
        period_with_employer_to: period_with_employer_to,
        tds_quarter_payments: {
          q1: tds_quarter_payments(:q1),
          q2: tds_quarter_payments(:q2),
          q3: tds_quarter_payments(:q3),
          q4: tds_quarter_payments(:q4),
          total: tds_quarter_payments(:total)
        }
      }
    }
  end
  
  private
  def certificate_number
    text.match(/for tax deducted at source on salary.*?No. ([A-Z]{7,7})/im)[1]
  end
  
  def last_updated_on
    text.match(/Last updated.*?([0-9]{2,2}-[A-Za-z]{3,3}-[0-9]{4,4})/im)[1]
  end
  
  def address_block
    text.match(/Name and address of the Employer.*?Name and address of the Employee(.*?[0-9]{6,6})(.*?[0-9]{6,6})/im)
  end
  
  def employer_address
    address_block[1].strip
  end
  
  def employee_address
    address_block[2].strip
  end
  
  def pan_tan_block
    text.match(/provided by the Employer.*?\(If available\).*?([A-Z]{5,5}[0-9]{4,4}[A-Z]).*?([A-Z]{4,4}[0-9]{5,5}[A-Z]).*?([A-Z]{5,5}[0-9]{4,4}[A-Z]).*?([0-9]{10,10})/im)
  end
  
  def pan_deductor
    pan_tan_block[1]
  end
  
  def tan_deductor
    pan_tan_block[2]
  end
  
  def pan_employee
    pan_tan_block[3]
  end
  
  def employee_reference_number
    pan_tan_block[4]
  end
  
  def assessment_year_block
    text.match(/Assessment Year.*?([0-9]{2,2}-[A-Z]{3,3}-[0-9]{4,4}).*?([0-9]{2,2}-[A-Z]{3,3}-([0-9]{4,4}))/im)
  end
  
  def assessment_year
    last_year = assessment_year_block[3]
    next_year = last_year.succ[-2..-1]
    "#{last_year}-#{next_year}"
  end
  
  def period_with_employer_from
    assessment_year_block[1]
  end
  
  def period_with_employer_to
    assessment_year_block[2]
  end
  
  def tds_quarter_payments(quarter)
    match_data = text.match(/Section 200.*?#{quarter}.*?([A-Z]{8,8})?.*?([0-9]+\.[0-9]{2,2}).*?([0-9]+\.[0-9]{2,2}).*?([0-9]+\.[0-9]{2,2})/im)
    {
      receipt_number: match_data[1],
      amount_credited: match_data[2],
      amount_tax_deducted: match_data[3],
      amount_tax_deposited: match_data[4]
    }
  end
end