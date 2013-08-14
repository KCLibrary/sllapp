FactoryGirl.define do
  
  sequence(:random_string) {|n| (0...8).map{(65+rand(26)).chr}.join }
  
  factory :user do
    first_name "John"
    last_name  "Doe"
    uid { generate(:random_string) }    
  end
  
  factory :reservation do
    start_datetime { (Time.now + rand(0..10).hours).beginning_of_hour }
    end_datetime { (start_datetime + rand(0..2).hours).end_of_hour }
    user
    resource
  end
  
  factory :resource do
    type "Desktop"
  end
  
end
