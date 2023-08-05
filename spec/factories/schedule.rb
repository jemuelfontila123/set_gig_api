FactoryBot.define do 
  factory :schedule do
    trait :production do 
      id { 1 }
      start_time {DateTime.new(2023,7,23,19)}
      end_time {  DateTime.new(2023,7,24,1)}
      schedule_type { Schedule.schedule_types[:production] }
      after(:create) do |schedule| 
        create(:booking, schedule_id: schedule.id) 
      end
    end

    trait :band do 
      id { 2 }
      start_time { DateTime.new(2023,7,24,19)}
      end_time {  DateTime.new(2023,7,24,19,30)}
      schedule_type  { Schedule.schedule_types[:band] }
      after(:create) do |schedule| 
        create(:booking, schedule_id: schedule.id)
      end
    end
  end
end

