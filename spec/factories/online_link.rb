FactoryBot.define do 
  factory :online_link do 
    sequence(:id) {|n| n}
    url {"youtube.com"}
  end
end