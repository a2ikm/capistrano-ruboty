# Capistrano::Ruboty

Ruboty specific capistrano tasks

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-ruboty', group: :development
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-ruboty

## Usage

```ruby
# Capfile
require 'capistrano/ruboty'
```

```ruby
# config/deploy.rb
append :linked_dirs, 'tmp/pids'  # corresponds to :ruboty_pid option
```

Configurable options, shown here with defaults:

```ruby
:ruboty_default_hooks   => { true }
:ruboty_role            => { :app }
:ruboty_servers         => { release_roles(fetch(:ruboty_role)) }
:ruboty_env             => { fetch(:ruboty_env, fetch(:stage)) }
:ruboty_command         => { [:ruboty] }
:ruboty_daemon          => { true }
:ruboty_dotenv          => { true }
:ruboty_pid             => { shared_path.join("tmp", "pids", "ruboty.pid") }
:ruboty_options         => { "" }
:ruboty_stop_signal     => { :TERM }
```

## shared `.env` file

You may need to exclude your `.env` file from your repository for security issues.

If so, you shall configure like below:

```ruby
# config/deploy.rb
append :linked_files, '.env'
```

, and put the `.env` file to the shared directory (its path is `<deploy_to>/shared/.env`) before deploying.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/a2ikm/capistrano-ruboty.

