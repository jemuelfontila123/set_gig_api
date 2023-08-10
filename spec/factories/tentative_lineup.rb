FactoryBot.define do 
  factory :tentative_lineup do  
    sequence(:id) {|n| n}
    band_name {Faker::Music.band} 
    genres {[Faker::Music.genre]}
  end
end