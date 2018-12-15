# frozen_string_literal: true

class TodoCommandHandler < Sequent::CommandHandler
  on AddTodo do |command|
    repository.add_aggregate Todo.new(command)
  end

  on CompleteTodo do |command|
    do_with_aggregate(command, Todo) do |todo|
      todo.complete(command.completion_time)
    end
  end
end
