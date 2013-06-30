# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    sender_id 1
    recipient_id 1
    notifiable_type "MyString"
    notifiable_id 1
    message "MyString"
  end
end
