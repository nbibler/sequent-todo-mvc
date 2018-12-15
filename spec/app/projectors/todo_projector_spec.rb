# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative '../../../app/projectors/todo_projector'

describe TodoProjector do
  let(:aggregate_id) { Sequent.new_uuid }
  let(:todo_projector) { TodoProjector.new }
  let(:todo_added) { TodoAdded.new(aggregate_id: aggregate_id, sequence_number: 1) }

  context TodoAdded do
    it 'creates a projection' do
      todo_projector.handle_message(todo_added)
      expect(TodoRecord.count).to eq(1)
      record = TodoRecord.first
      expect(record.aggregate_id).to eq(aggregate_id)
    end
  end

  context TodoCompleted do
    let(:todo_completed) do
      TodoCompleted.new(aggregate_id: aggregate_id, sequence_number: 2)
    end

    before { todo_projector.handle_message(todo_added) }

    it 'records the completed flag' do
      expect(TodoRecord.count).to eq(1)
      record = TodoRecord.first
      expect {
        todo_projector.handle_message(todo_completed)
      }.to change {
        record.reload
        record.completed?
      }.to(true)
    end
  end

  context TodoIncompleted do
    let(:todo_incompleted) do
      TodoIncompleted.new(aggregate_id: aggregate_id, sequence_number: 3)
    end

    before do
      todo_projector.handle_message(todo_added)
      todo_projector.handle_message(
        TodoCompleted.new(aggregate_id: aggregate_id, sequence_number: 2)
      )
    end

    it 'records the completed flag' do
      expect(TodoRecord.count).to eq(1)
      record = TodoRecord.first

      expect {
        todo_projector.handle_message(todo_incompleted)
      }.to change {
        record.reload
        record.completed?
      }.to(false)
    end
  end

  context TodoRemoved do
    let(:todo_removed) do
      TodoRemoved.new(aggregate_id: aggregate_id, sequence_number: 2)
    end

    before { todo_projector.handle_message(todo_added) }

    it 'removes the projection' do
      expect {
        todo_projector.handle_message(todo_removed)
      }.to change(TodoRecord, :count).by(-1)
    end
  end

  context TodoTitleChanged do
    let(:todo_title_changed) do
      TodoTitleChanged.new(aggregate_id: aggregate_id, title: 'ben en kim', sequence_number: 2)
    end

    before { todo_projector.handle_message(todo_added) }

    it 'updates a projection' do
      todo_projector.handle_message(todo_title_changed)
      expect(TodoRecord.count).to eq(1)
      record = TodoRecord.first
      expect(record.title).to eq('ben en kim')
    end
  end
end
