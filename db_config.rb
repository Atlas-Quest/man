require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'man'
}

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || options)
