# frozen_string_literal: true

class Todo < Sequent::AggregateRoot
  def initialize(command)
    super(command.aggregate_id)
    apply TodoAdded
    apply TodoTitleChanged, title: command.title
  end
end
