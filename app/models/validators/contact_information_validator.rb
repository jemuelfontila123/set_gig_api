class Validators::ContactInformationValidator < ActiveModel::Validator 
  def validate(record) 
    record.errors.add(:mobile_number, "it must start with 09, e.g 09123456789") if record.mobile_number.present? && !valid_mobile_number?(record.mobile_number)  
    password_rules(record) if record.password.present? && record.contact_type == 'user'
  end

  private 

  def valid_mobile_number?(phone_number)
    ph_number_pattern = /^09\d{9}$/
    ph_number_pattern.match(phone_number)
  end 

  def password_rules(record)
    record.errors.add :password, ' must contain at least 1 uppercase ' unless record.password.match(/\p{Upper}/)
    record.errors.add :password, ' must contain at least 1 lowercase' unless record.password.match(/\p{Lower}/)
    record.errors.add :password, ' must contain at least 1 number' unless record.password.count("0-9") > 0
    special = "?<>',?[]}{=-)(*&^%$#`~{}!"
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
    record.errors.add :password, ' must contain special character' unless record.password.match(regex)
    
  end

end