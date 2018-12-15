# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/reloader'
require_relative '../todo_mvc'

class Web < Sinatra::Base
  register Sinatra::Flash

  set :method_override, true

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    @todos = TodoRecord.order(:title)
    @incomplete_todos = @todos.where(completed: false)
    @complete_todos = @todos.where(completed: true)
    erb :index
  end

  get '/active' do
    @todos = TodoRecord.where(completed: false).order(:title)
    @incomplete_todos = @todos
    @complete_todos = []
    erb :index
  end

  get '/completed' do
    @todos = TodoRecord.where(completed: true).order(:title)
    @incomplete_todos = []
    @complete_todos = @todos
    erb :index
  end

  delete '/todos' do
    todos = TodoRecord.where(completed: true)
    commands = []
    todos.each do |todo|
      commands << RemoveTodo.new(aggregate_id: todo.aggregate_id)
    end
    Sequent.command_service.execute_commands(*commands)

    redirect '/'
  end

  post '/todos' do
    todo_id = Sequent.new_uuid
    command = AddTodo.from_params(params.merge(aggregate_id: todo_id))
    Sequent.command_service.execute_commands(command)

    redirect '/'
  end

  get '/todos/:aggregate_id/edit' do
    @todo = TodoRecord.find_by(aggregate_id: params[:aggregate_id])
    @todos = TodoRecord.order(:title)
    @incomplete_todos = @todos.where(completed: false)
    @complete_todos = @todos.where(completed: true)
    erb :index
  end

  patch '/todos/:aggregate_id' do
    command = ChangeTodoTitle.from_params(params)
    Sequent.command_service.execute_commands(command)

    redirect '/'
  end

  put '/todos/:aggregate_id/complete' do
    command = CompleteTodo.from_params(params)
    Sequent.command_service.execute_commands(command)

    redirect '/'
  end

  put '/todos/:aggregate_id/incomplete' do
    command = IncompleteTodo.from_params(params)
    Sequent.command_service.execute_commands(command)

    redirect '/'
  end

  delete '/todos/:aggregate_id' do
    command = RemoveTodo.from_params(params)
    Sequent.command_service.execute_commands(command)

    redirect '/'
  end

  helpers ERB::Util
end
