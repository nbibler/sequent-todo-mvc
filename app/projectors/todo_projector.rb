# frozen_string_literal: true

require_relative '../records/todo_record'
require_relative '../../lib/todo/events'

class TodoProjector < Sequent::Projector
  manages_tables TodoRecord

  on TodoAdded do |event|
    create_record(TodoRecord, aggregate_id: event.aggregate_id)
  end

  on TodoCompleted do |event|
    update_all_records(
      TodoRecord,
      { aggregate_id: event.aggregate_id },
      { completed_at: event.attributes[:completion_time] }
    )
  end

  on TodoTitleChanged do |event|
    update_all_records(
      TodoRecord,
      { aggregate_id: event.aggregate_id },
      event.attributes.slice(:title)
    )
  end
end
