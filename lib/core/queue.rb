require_relative "task"
require_relative "queued_task"

module Dawn
  class Queue < ActiveRecord::Base

    # --- Task Core {{{

    has_many :queued_tasks
    has_many :tasks, through: :queued_tasks

    def add_task(task)
      return unless task.is_a? Dawn::Task
      queued_tasks << Dawn::QueuedTask.create( queue: self, task: task )
    end

    alias_method :add, :add_task

    def remove_task(task)
      return unless has(task)

      queued_tasks.select { |queued_task| queued_task.task == task } .each do |queued_task|
        queued_tasks.delete(queued_task)
        queued_task.destroy
      end
    end

    alias_method :remove, :remove_task

    def has_task(task); tasks.include? task; end

    alias_method :has, :has_task

    def queued_task_for_task(task)
      queued_tasks.select { |queued_task| queued_task.task == task }.first
    end

    # --- }}}

    # --- Task Completion {{{

    def incomplete_queued_tasks
      queued_tasks.select { |queued_task| queued_task.incomplete? }
    end

    def complete_queued_tasks
      queued_tasks.select { |queued_task| queued_task.complete? }
    end

    def incomplete_tasks
      incomplete_queued_tasks.map { |queued_task| queued_task.task }
    end

    def complete_tasks
      complete_queued_tasks.map { |queued_task| queued_task.task }
    end

    def complete?(task)
      has(task) ? complete_tasks.include?(task) : false
    end

    alias_method :completed?, :complete?
    alias_method :has_completed?, :complete?

    def incomplete?(task)
      has(task) ? !complete?(task) : false
    end

    def mark_complete_tasks(tasks)
      tasks.each { |task| queued_task_for_task(task).update(complete: true) }
    end

    def mark_complete_task(*task); mark_complete_tasks(task); end

    alias_method :complete_task, :mark_complete_task
    alias_method :complete, :mark_complete_task

    def mark_incomplete_tasks(tasks)
      tasks.each { |task| queued_task_for_task(task).update(complete: false) }
    end

    def mark_incomplete_task(*task); mark_incomplete_tasks(task); end

    alias_method :incomplete_task, :mark_incomplete_task
    alias_method :incomplete, :mark_incomplete_task

    # --- }}}

    # --- Task Status {{{

    def current_queued_task
      queued_tasks.select { |queued_task| queued_task.current? }.first
    end

    def current_task
      current_queued_task().nil? ? nil : current_queued_task().task
    end

    def clear_current_queued_task
      current_queued_task.update(current: false) unless current_queued_task.nil?
    end

    alias_method :clear_current_task, :clear_current_queued_task

    def set_current_queued_task(queued_task)
      clear_current_queued_task()
      queued_task.update(current: true)
    end

    def set_current_task(task)
      set_current_queued_task(queued_task_for_task(task)) if has(task)
    end

    def complete_current_task; complete(current_queued_task); end

    # --- }}}

    # --- Status {{{

    def finished?; incomplete_queued_tasks.empty?; end

    def started?; current_queued_task.nil? and complete_queued_tasks.empty?; end

    # --- }}}

    # --- Selection {{{

    def sample; incomplete_tasks.sample; end

    # --- }}}

  end
end

