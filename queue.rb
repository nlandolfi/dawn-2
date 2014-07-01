require_relative "queued_task"

module Dawn
  class Queue < ActiveRecord::Base

    # --- Tasks {{{

    has_many :queued_tasks
    has_many :tasks, through: :queued_tasks

    def incomplete_tasks
      queued_tasks.select { |task| task.incomplete? }.map { |queued_task| queued_task.task }
    end

    def complete_tasks
      queued_tasks.select { |task| task.complete? }.map { |queued_task| queued_task.task }
    end

    def has(task)
      tasks.include? task
    end

    alias_method :has_task, :has

    def complete?(task)
      has(task) ? complete_tasks.include?(task) : false
    end

    alias_method :completed?, :complete?
    alias_method :has_completed?, :complete?

    def incomplete?(task)
      has(task) ? !complete?(task) : false
    end

    def add_task(task)
      queued_tasks << Dawn::QueuedTask.create( queue: self, task: task )
    end

    def remove_task(task)
      return unless has(task)

      queued_tasks.select { |queued_task| queued_task.task == task } .each do |queued_task|
        queued_tasks.delete(queued_task)
        queued_task.destroy
      end
    end

    # --- }}}

  end
end

