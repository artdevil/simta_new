# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :todo_final_project do
    final_project_id 1
    user_id 1
    issue_number 1
    title "MyString"
    message "MyText"
    status false
    slug "MyString"
  end
end
