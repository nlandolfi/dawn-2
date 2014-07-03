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
  end


  create_table :task_dependencies, force: $force_db do |table|
    table.integer :task_id
    table.integer :dependent_id
  end

  add_index(:task_dependencies, [:task_id, :dependent_id], unique: true)
  add_index(:task_dependencies, [:dependent_id, :task_id], unique: true)

  # --- }}}

  # --- Queues {{{

  create_table :queued_tasks, force: $force_db do |table|
    table.integer :task_id
    table.integer :queue_id
    table.boolean :complete, default: false
    table.boolean :current, default: false

    table.timestamps
  end

  create_table :queues, force: $force_db do |table|
    table.timestamps
  end

  create_table :queued_queues, force: $force_db do |table|
    table.integer :queue_id
    table.integer :meta_queue_id

    table.timestamps
  end

  create_table :meta_queues, force: $force_db do |table|
    table.timestamps
  end

  # --- }}}

  # --- Services {{{

  create_table :services, force: $force_db do |table|

    table.timestamps
  end

  create_table :servers, force: $force_db do |table|
    table.integer :service_id
    table.integer :meta_service_id

    table.timestamps
  end

  create_table :meta_services, force: $force_db do |table|
    table.timestamps
  end

  # --- }}}

end

Dir[File.expand_path("../core/*.rb", __FILE__)].sort.each { |file| require file }
