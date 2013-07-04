# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :proposal do
    topic_id 1
    user_id 1
    advisor_1_id 1
    advisor_2_id 1
    title "MyString"
    description "MyText"
    progress 1
  end
end
