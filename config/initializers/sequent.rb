# frozen_string_literal: true

require './db/migrations'

Sequent.configure do |config|
  config.migrations_class_name = 'Migrations'

  config.command_handlers = [
    PostCommandHandler.new,
    TodoCommandHandler.new
  ]

  config.event_handlers = [
    PostProjector.new
  ]
end
