# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :news do
    admin_user_id 1
    title "MyString"
    description "MyText"
  end
end
