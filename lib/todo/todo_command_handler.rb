# frozen_string_literal: true

class TodoCommandHandler < Sequent::CommandHandler
  on AddTodo do |command|
    repository.add_aggregate Todo.new(command)
  end
end
