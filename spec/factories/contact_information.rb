FactoryBot.define do 
  factory :contact_information do 
    sequence(:id) {|n| n}
    first_name {"Jemu"} 
    last_name {"Fon"} 
    email_address {"jemufon@gmail.com"}
    mobile_number {"09196022572"}
  end

end