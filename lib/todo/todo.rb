# frozen_string_literal: true

class Todo < Sequent::AggregateRoot
  Error = Class.new(StandardError)
  TodoAlreadyCompleted = Class.new(Error)
  TodoAlreadyRemoved = Class.new(Error)

  def initialize(command)
    super(command.aggregate_id)
    apply TodoAdded
    apply TodoTitleChanged, title: command.title
  end

  def change_title(title)
    fail TodoAlreadyRemoved if @removed
    return if title == @title
    apply TodoTitleChanged, title: title
  end

  def complete(time)
    fail TodoAlreadyCompleted if @completion_time
    fail TodoAlreadyRemoved if @removed
    apply TodoCompleted, completion_time: time
  end

  def remove
    return if @removed
    apply TodoRemoved
  end

  on TodoAdded do |event|
  end

  on TodoCompleted do |event|
    @completion_time = event.completion_time
  end

  on TodoRemoved do |event|
    @removed = true
  end

  on TodoTitleChanged do |event|
    @title = event.title
  end
end
