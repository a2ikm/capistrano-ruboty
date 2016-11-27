namespace :load do
  task :defaults do
    set :ruboty_default_hooks,  -> { true }

    set :ruboty_role,         -> { :app }
    set :ruboty_servers,      -> { release_roles(fetch(:ruboty_role)) }
    set :ruboty_env,          -> { fetch(:ruboty_env, fetch(:stage)) }
    set :ruboty_command,      -> { [:ruboty] }
    set :ruboty_daemon,       -> { true }
    set :ruboty_dotenv,       -> { true }
    set :ruboty_pid,          -> { shared_path.join("tmp", "pids", "ruboty.pid") }
    set :ruboty_options,      -> { "" }
    set :ruboty_stop_signal,  -> { :TERM }

    # Rbenv, Chruby, and RVM integration
    set :rbenv_map_bins,  fetch(:rbenv_map_bins).to_a.concat(%w(ruboty))
    set :rvm_map_bins,    fetch(:rvm_map_bins).to_a.concat(%w(ruboty))
    set :chruby_map_bins, fetch(:chruby_map_bins).to_a.concat(%w(ruboty))

    # Bundler integration
    set :bundle_bins,     fetch(:bundle_bins).to_a.concat(%w(ruboty))
  end
end

namespace :deploy do
  before :starting, :check_ruboty_hooks do
    invoke "ruboty:add_default_hooks" if fetch(:ruboty_default_hooks)
  end
end

namespace :ruboty do
  task :start do
    command_args  = []
    command_args += Array(fetch(:ruboty_command))
    command_args += %w(--dotenv) if fetch(:ruboty_dotenv)
    command_args += %w(--daemon) if fetch(:ruboty_daemon)
    command_args += ["--pid", fetch(:ruboty_pid)] if fetch(:ruboty_pid)
    command_args += Array(fetch(:ruboty_options))

    on fetch(:ruboty_servers) do
      within release_path do
        with ruboty_env: fetch(:ruboty_env) do
          execute(*command_args)
        end
      end
    end
  end

  task :stop do
    on fetch(:ruboty_servers) do
      within release_path do
        with ruboty_env: fetch(:ruboty_env) do
          pid = existing_pid(fetch(:ruboty_pid))
          if pid
            execute :kill, "-s", fetch(:ruboty_stop_signal), pid
          else
            info "ruboty is not running."
          end
        end
      end
    end
  end

  def existing_pid(pid_file)
    unless test("[ -f #{pid_file} ]")
      debug "#{pid_file} does not exist."
      return nil
    end

    pid = capture("cat #{pid_file}").strip

    unless test("kill -0 #{pid}")
      debug "process #{pid} does not exist."
      return nil
    end

    pid
  end

  task :restart do
    invoke "ruboty:stop"
    invoke "ruboty:start"
  end

  task :add_default_hooks do
    after "deploy:publishing", "ruboty:restart"
  end
end
