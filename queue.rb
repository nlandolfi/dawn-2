
module Dawn
  class Queue < ActiveRecord::Base

    # --- Tasks {{{

    has_many :complete_tasks
    has_many :incomplete_tasks
    belongs_to  :current_task, foreign_key: :current_task_id, class: "Task"
    belongs_to  :previous_task, foreign_key: :previous_task_id, class: "Task"

    def tasks
      incomplete_tasks.concat(complete_tasks)
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
      incomplete_tasks << task unless has(task)
    end

    def remove_task(task)
      return unless has(task)

      if complete?(task)
        complete_tasks.delete(task)
      else
        incomplete_tasks.delete(task)
      end
    end

    # --- }}}

    def next

    end

  end
end

