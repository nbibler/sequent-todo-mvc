# frozen_string_literal: true

class TodoAdded < Sequent::Event
end

class TodoCompleted < Sequent::Event
  attrs completion_time: DateTime
end

class TodoRemoved < Sequent::Event
end

class TodoTitleChanged < Sequent::Event
  attrs title: String
end
