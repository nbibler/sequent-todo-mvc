# frozen_string_literal: true

class Todo < Sequent::AggregateRoot
  TodoAlreadyCompleted = Class.new(StandardError)

  def initialize(command)
    super(command.aggregate_id)
    apply TodoAdded
    apply TodoTitleChanged, title: command.title
  end

  def complete(time)
    fail TodoAlreadyCompleted if @completion_time
    apply TodoCompleted, completion_time: time
  end

  on TodoAdded do |event|
  end

  on TodoCompleted do |event|
    @completion_time = event.completion_time
  end

  on TodoTitleChanged do |event|
    @title = event.title
  end
end
