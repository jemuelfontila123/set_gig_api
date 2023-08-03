
FactoryBot.define do 
  factory :admin do 
    trait :valid do 
      id { 1 }
      username {'superadmin'}
      password {'Minimumisten1#'}
    end 

    trait :invalid do 
      username {'superadmin'}
      password {'Minimumisten1'}
    end 
  end

end