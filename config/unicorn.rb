working_directory "/Users/adhigunasabril/Documents/kerja/rails/simta_new"
pid "/Users/adhigunasabril/Documents/kerja/rails/simta_new/tmp/pids/unicorn.pid"
stderr_path "/Users/adhigunasabril/Documents/kerja/rails/simta_new/unicorn/unicorn.log"
stdout_path "/Users/adhigunasabril/Documents/kerja/rails/simta_new/unicorn/unicorn.log"

listen "/tmp/unicorn.todo.sock"
worker_processes 4
timeout 30

preload_app true

before_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end