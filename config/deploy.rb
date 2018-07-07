require 'capistrano-db-tasks'

# if you haven't already specified
set :rails_env, "production"

# if you want to remove the local dump file after loading
set :db_local_clean, true

# if you want to remove the dump file from the server after downloading
set :db_remote_clean, true

# configure location where the dump file should be created
set :db_dump_dir, "./db"

# if you are highly paranoid and want to prevent any push operation to the server
set :disallow_pushing, true
