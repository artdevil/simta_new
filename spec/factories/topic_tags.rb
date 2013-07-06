# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic_tag do
    user_id 1
    topic_id 1
    status false
  end
end
