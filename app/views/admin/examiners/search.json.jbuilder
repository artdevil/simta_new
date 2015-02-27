json.array! @user do |user|
  json.value user.username
  json.id user.id
end