# frozen_string_literal: true

class TodoAdded < Sequent::Event
end

class TodoTitleChanged < Sequent::Event
  attrs title: String
end
