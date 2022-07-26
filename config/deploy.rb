# config valid for current version and patch releases of Capistrano
lock '~> 3.17.0'

set :application, 'qna'
set :repo_url, 'git@github.com:semliko/stackoverflow.git'
set :branch, 'main'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

set :rvm_type, :system
# set :rvm_roles, %i[app web]
# set :use_sudo, true
# set :default_env, { rvm_bin_path: '~/.rvm/bin' }
set :rvm_ruby_version, '2.7.1'
# set :rvm_ruby_version, 'default'

Rake::Task['deploy:assets:backup_manifest'].clear_actions
set :passenger_restart_with_touch, true
# set :passenger_restart_with_sudo, true

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/webpacker', 'public/system', 'vendor/bundle',
       'storage'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
