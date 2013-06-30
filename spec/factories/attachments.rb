# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment do
    attachmentable_id 1
    attachmentable_type "MyString"
    file "MyString"
  end
end
