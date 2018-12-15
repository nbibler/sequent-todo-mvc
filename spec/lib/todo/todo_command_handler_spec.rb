# frozen_string_literal: true

require_relative '../../../lib/todo'

RSpec.describe TodoCommandHandler do
  let(:aggregate_id) { Sequent.new_uuid }

  before :each do
    Sequent.configuration.command_handlers = [TodoCommandHandler.new]
  end

  context AddTodo do
    it 'creates a todo' do
      when_command(
        AddTodo.new(aggregate_id: aggregate_id, title: 'My first Todo')
      )
      then_events(
        TodoAdded.new(aggregate_id: aggregate_id, sequence_number: 1),
        TodoTitleChanged.new(
          aggregate_id: aggregate_id,
          sequence_number: 2,
          title: 'My first Todo'
        )
      )
    end
  end

  context ChangeTodoTitle do
    it 'changes the title' do
      given_events(
        TodoAdded.new(aggregate_id: aggregate_id, sequence_number: 1),
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

    it 'ignores if unchanged' do
      given_events(
        TodoAdded.new(aggregate_id: aggregate_id, sequence_number: 1),
        TodoTitleChanged.new(
          aggregate_id: aggregate_id,
          sequence_number: 2,
          title: 'My first Todo'
        )
      )
      when_command(
        ChangeTodoTitle.new(aggregate_id: aggregate_id, title: 'My first Todo')
      )
      then_events()
    end

    it 'fails when changing a removed todo' do
      given_events(
        TodoAdded.new(aggregate_id: aggregate_id, sequence_number: 1),
        TodoRemoved.new(aggregate_id: aggregate_id, sequence_number: 2)
      )
      expect {
        when_command(
          ChangeTodoTitle.new(aggregate_id: aggregate_id, title: 'Boom')
        )
      }.to raise_error(Todo::TodoAlreadyRemoved)
    end
  end

  context CompleteTodo do
    it 'completes a todo' do
      given_events(
        TodoAdded.new(aggregate_id: aggregate_id, sequence_number: 1)
      )
      when_command(CompleteTodo.new(aggregate_id: aggregate_id))
      then_events(
        TodoCompleted.new(aggregate_id: aggregate_id, sequence_number: 2)
      )
    end

    it 'fails when completing a completed todo' do
      given_events(
        TodoAdded.new(aggregate_id: aggregate_id, sequence_number: 1),
        TodoCompleted.new(aggregate_id: aggregate_id, sequence_number: 2)
      )
      expect {
        when_command(CompleteTodo.new(aggregate_id: aggregate_id))
      }.to raise_error(Todo::TodoAlreadyCompleted)
    end

    it 'fails when completing a removed todo' do
      given_events(
        TodoAdded.new(aggregate_id: aggregate_id, sequence_number: 1),
        TodoRemoved.new(aggregate_id: aggregate_id, sequence_number: 2)
      )
      expect {
        when_command(CompleteTodo.new(aggregate_id: aggregate_id))
      }.to raise_error(Todo::TodoAlreadyRemoved)
    end
  end

  context RemoveTodo do
    it 'removes a todo' do
      given_events(
        TodoAdded.new(aggregate_id: aggregate_id, sequence_number: 1)
      )
      when_command(RemoveTodo.new(aggregate_id: aggregate_id))
      then_events(
        TodoRemoved.new(aggregate_id: aggregate_id, sequence_number: 2)
      )
    end

    it 'ignores when already removed' do
      given_events(
        TodoAdded.new(aggregate_id: aggregate_id, sequence_number: 1),
        TodoRemoved.new(aggregate_id: aggregate_id, sequence_number: 2)
      )
      when_command(RemoveTodo.new(aggregate_id: aggregate_id))
      then_events()
    end
  end
end
