# frozen_string_literal: true

class AddTodo < Sequent::Command
  attrs title: String
  validates_presence_of :title
end
