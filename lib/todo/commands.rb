# frozen_string_literal: true

class AddTodo < Sequent::Command
  attrs title: String
  validates_presence_of :title
end

class CompleteTodo < Sequent::Command
  attrs completion_time: DateTime
  validates_presence_of :completion_time
end
