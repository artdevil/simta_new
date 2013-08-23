# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment_admin do
    attachment_adminable_id 1
    attachment_adminable_type "MyString"
    file "MyString"
  end
end
