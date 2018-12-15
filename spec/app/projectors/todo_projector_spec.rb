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
