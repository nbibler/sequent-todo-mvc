# frozen_string_literal: true

require 'yaml'
require 'erb'
require 'active_record'

class Database
  class << self
    def database_config(env = ENV['RACK_ENV'])
      @config ||= YAML.load(ERB.new(File.read('db/database.yml')).result)[env]
    end

    def establish_connection(env = ENV['RACK_ENV'])
      config = database_config(env)
      yield(config) if block_given?
      ActiveRecord::Base.configurations[env.to_s] = config.stringify_keys
      ActiveRecord::Base.establish_connection config
    end
  end
end
