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

puts 'creating topic'

# deskripsi TA

description = '<p><span style="color: rgb(0, 0, 0); font-family: Arial, Helvetica, sans; font-size: 11px; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: 14px; orphans: 2; text-align: justify; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; display: inline !important; float: none;">
              Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
              Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
              Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
              </span></p>'
# judul TA

topics = [
  {:user_id => 9, :title => "Perancangan dan implementasi monitoring tugas akhir", :tag_list => "monitoring", :description => "#{description}"},
  {:user_id => 9, :title => "perancangan quadcopter dengan menggunakan raspberry", :tag_list => "quadcopter, raspberry", :description => "#{description}"},
  {:user_id => 9, :title => "augmented reality untuk jalan raya", :tag_list => "augmented reality", :description => "#{description}"},
  {:user_id => 9, :title => "perancangan web services untuk rumah sakit", :tag_list => "web services, rumah sakit", :description => "#{description}"},
  {:user_id => 10, :title => "pencarian lokasi terdekat dengan menggunakan algoritma djikstra", :tag_list => "algoritma djikstra", :description => "#{description}"},
  {:user_id => 10, :title => "monitoring pada jalur kereta api", :tag_list => "monitoring, kereta api", :description => "#{description}"},
  {:user_id => 10, :title => "pencitraan menggunakan matlab", :tag_list => "pencitraan,matlab", :description => "#{description}"},
  {:user_id => 11, :title => "pembuatan aplikasi web dengan menggunakan node.js", :tag_list => "aplikasi web,node.js", :description => "#{description}"},
  {:user_id => 11, :title => "aplikasi android untuk monitoring kesehatan", :tag_list => "android,monitoring, kesehatan", :description => "#{description}"},
  {:user_id => 10, :title => "antena mikrostrip", :tag_list => "antena, mikrostrip", :description => "#{description}"},
  {:user_id => 9, :title => "collaborator application dengan ruby on rails web framework", :tag_list => "collaborator application,ruby on rails, web framework", :description => "#{description}"}
]

# bikin TA
topics.each do |f|
  Topic.create(f)
end