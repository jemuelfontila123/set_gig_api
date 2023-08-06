FactoryBot.define do 
  factory :booking do 
    sequence(:id) { |n| n}
    name {"band booking"}
    description {"etc booking"}
    previous_events {"dati rati"}
    schedule nil 
  end
end