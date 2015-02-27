# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :examiner do
    datetime "2014-01-01 14:05:03"
    location "MyString"
    note "MyText"
    project_id 1
    examiner_1 1
    examiner_2 1
    examiner_3 1
  end
end
