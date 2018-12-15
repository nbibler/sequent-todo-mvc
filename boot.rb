# frozen_string_literal: true

require './app/database'
Database.establish_connection

require './app/web'
