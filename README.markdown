# Sequent TodoMVC-ish

This is a TodoMVC-like thing for experimenting with sequent.

This uses a dumb, server-side app-style Sinatra application rather being run
entirely in a JavaScript client. All data is persisted to the server/PostgreSQL
database and recalled on subsequent requests.

## Installation and Setup

Download the repository, then:

```
bundle install
bundle exec rake sequent:db:create
RACK_ENV=test bundle exec rake sequent:db:create
bundle exec rake sequent:db:create_view_schema
bundle exec rake sequent:migrate:online
bundle exec rake sequent:migrate:offline
```

Run the sinatra app with:

```
rackup
```

And then go to http://localhost:9292/.

## Inspecting the World

Once you've generated some data (done stuff in the app), you can see what data
is generated in the system by opening the PostgreSQL console:

```
psql todo_mvc_development
```

And then inspecting the tables. For example:

```sql
SELECT * FROM sequent_schema.event_records;
SELECT * FROM view_schema.todo_records;
```

To get a list of all available schemas and tables, try running `\dt *.*`.
