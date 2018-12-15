# frozen_string_literal: true

class AddTodo < Sequent::Command
  attrs title: String
  validates_presence_of :title
end

class ChangeTodoTitle < Sequent::Command
  attrs title: String
  validates_presence_of :title
end

class CompleteTodo < Sequent::Command
end

class RemoveTodo < Sequent::Command
end
