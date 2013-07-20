# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    commentable_id 1
    commentable_type "MyString"
    user_id 1
    comment "MyText"
  end
end
