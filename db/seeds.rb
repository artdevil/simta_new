# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#create user role
puts 'creating user roles'
role_users = [
  {:name => "student"},
  {:name => "lecture"},
  {:name => "admin"},
  {:name => "kaprodi"}
]
role_users.each do |f|
  UserRole.find_or_initialize_by_name(f[:name]).tap do |t|
    t.save!
  end
end

#create users
puts 'creating users'
users = [
  {:username => "Adhiguna Utama Sabril", :keyid => "111128355", :password => "tes123456", :faculty_id => 2},
  {:username => "Ana Riana Januardini", :keyid => "111128376", :password => "tes123456", :faculty_id => 2},
  {:username => "Bambang Joko Widodo", :keyid => "111128383", :password => "tes123456", :faculty_id => 2},
  {:username => "Al Bukhari Pahlevi", :keyid => "111128369", :password => "tes123456", :faculty_id => 2},
  {:username => "Mita Mushliha", :keyid => "111128386", :password => "tes123456", :faculty_id => 2},
  {:username => "Rifky Sintami", :keyid => "111128365", :password => "tes123456", :faculty_id => 2},
  {:username => "Santy Fauziyah", :keyid => "111128370", :password => "tes123456", :faculty_id => 2},
  {:username => "Al Bukhari Pahlevi", :keyid => "111128369", :password => "tes123456", :faculty_id => 2},
  {:username => "Nira Pebriani", :keyid => "111128382", :password => "tes123456", :faculty_id => 2},
  {:username => "Burhanuddin Dirgantara,Ir,MT.", :keyid => "93680086-1", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Efri Suhartono, ST., MT.", :keyid => "99730171-1", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Istikmal,ST,MT.", :keyid => "08790474-1", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Muhammad Iqbal,ST,MT.", :keyid => "10840586-1", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Tody Ariefianto Wibowo,ST ,MT.", :keyid => "10820584-1", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Rita Magdalena,Ir,MT.", :keyid => "99640168-1", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Leana Vidya Yovita,ST.,MT.", :keyid => "08830413-1", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Ridha Muldina, ST.", :keyid => "10850626-3", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Ida Wahidah,ST,MT.", :keyid => "99760186-1", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Sofia Naning H, Ir., MT.", :keyid => "99710170-1", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Ratna Mayasari, ST.", :keyid => "10850624-3", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Indrarini Dyah,ST,MT.", :keyid => "07780394-1", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "A Ali Muayyadi,Ir,MSc,PhD.", :keyid => "93660096-1", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Koredianto Usman,ST.,MSc.", :keyid => "02750290-1", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Rita Magdalena,Ir,MT.", :keyid => "99640168-1", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Tengku A. Riza, ST., MT.", :keyid => "10790594-1", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Denny Darlis, S.Si., M.T", :keyid => "10770726-3", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => "Ekki Kurniawan, ST., MSc.", :keyid => "10690733-3", :password => "tes123456", :user_role_id => 2, :faculty_id => 2},
  {:username => 'mohammad ramdhani',:keyid => "02730260-1", :password => 'tes123456', :user_role_id => 4, :faculty_id => 2},
  {:username => 'admin',:keyid => "02730261-1", :password => 'tes123456', :user_role_id => 3, :faculty_id => 2},
]
users.each do |f|
  User.find_or_initialize_by_keyid(f[:keyid]).tap do |t|
    t.username = f[:username]
    t.password = f[:password]
    t.password_confirmation = f[:password]
    t.user_role_id = f[:user_role_id] || 1
    t.faculty_id = 2
    t.save
  end
  # User.create(:username => f[:username], :password => f[:password], :password_confirmation => f[:password], :user_role_id => (f[:user_role_id] || 1), :faculty_id => 2)
end

puts 'creating topic'

# deskripsi TA

description = '<p>
              Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
              Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
              Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
              </p>'
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
  {:user_id => 11, :title => "antena mikrostrip", :tag_list => "antena, mikrostrip", :description => "#{description}"},
  {:user_id => 10, :title => "collaborator application dengan ruby on rails web framework", :tag_list => "collaborator application,ruby on rails, web framework", :description => "#{description}"}
]

# bikin TA
topics.each do |f|
  Topic.create(f)
end

#news
news_description = "<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum</p>

<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum</p>

<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum</p>

<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum</p>
"

#bikin news
puts 'creating news'
(1..6).each do |f|
  News.create(:title => "berita tes #{f}", :description => news_description, :admin_user_id => 1)
end