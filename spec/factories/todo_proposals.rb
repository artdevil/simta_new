# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :todo_proposal do
    proposal_id 1
    user_id 1
    title "MyString"
    message "MyText"
    status false
  end
end
