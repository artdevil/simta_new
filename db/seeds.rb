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

#create user role
puts 'creating user roles'
role_users = [
  {:name => "student"},
  {:name => "lecture"}
]
role_users.each do |f|
  UserRole.find_or_initialize_by_name(f[:name]).tap do |t|
    t.save!
  end
end

#create users
puts 'creating users'
users = [
  {:name => "adhiguna utama sabril", :keyid => "111128355", :password => "tes123456"},
  {:name => "ana riana", :keyid => "111128376", :password => "tes123456"},
  {:name => "Bambang Joko Widodo", :keyid => "111128383", :password => "tes123456"},
  {:name => "Mita Mushliha", :keyid => "111128386", :password => "tes123456"},
  {:name => "Rifky Sintami", :keyid => "111128365", :password => "tes123456"},
  {:name => "Santy Fauziyah", :keyid => "111128370", :password => "tes123456"},
  {:name => "Al Bukhari Pahlevi", :keyid => "111128369", :password => "tes123456"},
  {:name => "Nira Pebriani", :keyid => "111128382", :password => "tes123456"},
  {:name => "Burhanuddin Dirgantara,Ir,MT.", :keyid => "93680086-1", :password => "tes123456", :user_role_id => 2},
  {:name => "Efri Suhartono, ST., MT.", :keyid => "99730171-1", :password => "tes123456", :user_role_id => 2},
  {:name => "Istikmal,ST,MT.", :keyid => "08790474-1", :password => "tes123456", :user_role_id => 2}
]
users.each do |f|
  User.find_or_initialize_by_keyid(f[:keyid]).tap do |t|
    t.username = f[:name]
    t.password = f[:password]
    t.user_role_id = f[:user_role_id] || 1
    t.save!
  end
end