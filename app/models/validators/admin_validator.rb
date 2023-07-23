class Validators::AdminValidator < ActiveModel::Validator 

  def validate(record)
    password_rules(record) unless record.password.nil?
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