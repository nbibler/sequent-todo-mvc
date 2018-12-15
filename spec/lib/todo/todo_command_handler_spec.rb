# frozen_string_literal: true

require_relative '../../../lib/todo'

RSpec.describe TodoCommandHandler do
  let(:aggregate_id) { Sequent.new_uuid }

  before :each do
    Sequent.configuration.command_handlers = [TodoCommandHandler.new]
  end

  it 'creates a todo' do
    when_command AddTodo.new(aggregate_id: aggregate_id, title: 'My first Todo')
    then_events(
      TodoAdded.new(aggregate_id: aggregate_id, sequence_number: 1),
      TodoTitleChanged.new(aggregate_id: aggregate_id, sequence_number: 2, title: 'My first Todo')
    )
  end
end
