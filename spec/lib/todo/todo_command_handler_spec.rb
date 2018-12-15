# frozen_string_literal: true

require_relative '../../../lib/todo'

RSpec.describe TodoCommandHandler do
  let(:aggregate_id) { Sequent.new_uuid }

  before :each do
    Sequent.configuration.command_handlers = [TodoCommandHandler.new]
  end

  it 'creates a todo' do
    when_command(
      AddTodo.new(
        aggregate_id: aggregate_id,
        title: 'My first Todo'
      )
    )
    then_events(
      TodoAdded.new(
        aggregate_id: aggregate_id,
        sequence_number: 1
      ),
      TodoTitleChanged.new(
        aggregate_id: aggregate_id,
        sequence_number: 2,
        title: 'My first Todo'
      )
    )
  end

  it 'changes the title' do
    given_events(
      TodoAdded.new(
        aggregate_id: aggregate_id,
        sequence_number: 1
      ),
      TodoTitleChanged.new(
        aggregate_id: aggregate_id,
        sequence_number: 2,
        title: 'My first Todo'
      )
    )
    when_command(
      ChangeTodoTitle.new(
        aggregate_id: aggregate_id,
        title: 'My second Todo'
      )
    )
    then_events(
      TodoTitleChanged.new(
        aggregate_id: aggregate_id,
        sequence_number: 3,
        title: 'My second Todo'
      )
    )
  end

  it 'ignores a title change if unchanged' do
    given_events(
      TodoAdded.new(
        aggregate_id: aggregate_id,
        sequence_number: 1
      ),
      TodoTitleChanged.new(
        aggregate_id: aggregate_id,
        sequence_number: 2,
        title: 'My first Todo'
      )
    )
    when_command(
      ChangeTodoTitle.new(
        aggregate_id: aggregate_id,
        title: 'My first Todo'
      )
    )
    then_events()
  end

  it 'completes a todo' do
    completion_time = DateTime.new(2018, 12, 14, 20, 28, 0, '-05:00')

    given_events(
      TodoAdded.new(
        aggregate_id: aggregate_id,
        sequence_number: 1
      )
    )
    when_command(
      CompleteTodo.new(
        aggregate_id: aggregate_id,
        completion_time: completion_time
      )
    )
    then_events(
      TodoCompleted.new(
        aggregate_id: aggregate_id,
        sequence_number: 2,
        completion_time: completion_time
      )
    )
  end

  it 'fails when completing a completed todo' do
    completion_time = DateTime.new(2018, 12, 14, 20, 28, 0, '-05:00')

    given_events(
      TodoAdded.new(
        aggregate_id: aggregate_id,
        sequence_number: 1
      ),
      TodoCompleted.new(
        aggregate_id: aggregate_id,
        completion_time: completion_time,
        sequence_number: 1
      )
    )
    expect {
      when_command(
        CompleteTodo.new(
          aggregate_id: aggregate_id,
          completion_time: completion_time
        )
      )
    }.to raise_error(Todo::TodoAlreadyCompleted)
  end
end
