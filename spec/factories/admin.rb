
FactoryBot.define do 
  factory :admin do 
    trait :valid do 
      username {'superadmin'}
      password {'Minimumisten1#'}
    end 

    trait :invalid do 
      username {'superadmin'}
      password {'Minimumisten1'}
    end 
  end

end