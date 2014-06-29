# encoding UTF-8

require "rubygems"
require "bundler"

Bundler.require

ActiveRecord::Base.establish_connection(
  adapter:  "sqlite3",
  database: "db/dawn.db"
)

$force_db = ENV["FORCE_DB"] || true;

ActiveRecord::Schema.define do

  # --- Tasks {{{

  create_table :tasks, force: $force_db do |table|
    table.string :name
    table.timestamps

    table.integer :parent_task_id, unique: true
    table.integer :queue_id
  end


  create_table :task_dependencies, force: $force_db do |table|
    table.integer :task_id
    table.integer :dependent_id
  end

  add_index(:task_dependencies, [:task_id, :dependent_id], unique: true)
  add_index(:task_dependencies, [:dependent_id, :task_id], unique: true)

  # --- }}}

  create_table :queued_tasks, force: $force_db do |table|

    table.timestamps
  end


  create_table :queues, force: $force_db do |table|
    table.integer :current_task_id
    table.integer :previous_task_id
  end

end


require_relative "task.rb"
require_relative "queue.rb"
