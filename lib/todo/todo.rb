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

  def complete
    fail TodoAlreadyCompleted if @completed
    fail TodoAlreadyRemoved if @removed
    apply TodoCompleted
  end

  def remove
    return if @removed
    apply TodoRemoved
  end

  on TodoAdded do |event|
  end

  on TodoCompleted do |event|
    @completed = true
  end

  on TodoRemoved do |event|
    @removed = true
  end

  on TodoTitleChanged do |event|
    @title = event.title
  end
end
