# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document do
    admin_id 1
    name "MyString"
    file "MyString"
    document_type "MyString"
  end
end
