# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#create admin roles
puts 'creating admin roles'
role_admins = [
  {:name => "kaprodi"},
  {:name => "admin"}
]
role_admins.each do |f|
  UserAdminRole.find_or_initialize_by_name(f[:name]).tap do |t|
    t.save!
  end
end