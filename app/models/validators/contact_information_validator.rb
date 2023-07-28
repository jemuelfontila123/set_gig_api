class Validators::ContactInformationValidator < ActiveModel::Validator 
  def validate(record) 
    record.errors.add(:mobile_number, "it must start with 09, e.g 09123456789") if record.mobile_number.present? && !valid_mobile_number?(record.mobile_number)
  end

  private 

  def valid_mobile_number?(phone_number)
    ph_number_pattern = /^09\d{9}$/
    ph_number_pattern.match(phone_number)
  end

end