
module Dawn
  class Task < ActiveRecord::Base

    # --- Core {{{

    def key
      self.name.downcase.to_sym
    end

    # --- }}}

    # --- Queues {{{

    has_many :queued_tasks
    has_many :queues, through: :queued_tasks

    # --- }}}

    # --- Dependencies {{{

    has_and_belongs_to_many :dependencies,
             class_name: "Task",
             join_table: :task_dependencies,
             foreign_key: :task_id,
             association_foreign_key: :dependent_id

    def add_dependency(task)
      dependencies << task unless dependence(task)

      self
    end

    def remove_dependency(task)
      dependencies.delete(task)

      self
    end

    def no_dependencies?
      dependencies.empty?
    end

    alias_method :has_no_dependencies?, :no_dependencies?

    def dependencies?; !no_dependencies?; end

    alias_method :has_dependencies?, :dependencies?

    def has_dependency(task)
      dependencies.to_a.include? task
    end

    def dependence(task)
      self.has_dependency(task) or task.has_dependency(self)
    end


    # --- }}}

    # --- Tree Nature {{{

    belongs_to :parent, class_name: "Task", foreign_key: :parent_task_id
    has_many :children, class_name: 'Task', foreign_key: :parent_task_id

    def subtasks; children; end

    def parents
      if parent and parent.parent
        [parent] + parent.parents
      elsif parent
        [parent]
      else
        []
      end
    end

    def root?
      parent.nil?
    end

    alias_method :is_root?, :root?
    alias_method :has_parent?, :root?

    def child?
      !root?
    end

    alias_method :is_child?, :child?

    def parent?
      !children.empty?
    end

    alias_method :is_parent?, :parent?
    alias_method :children?, :parent?

    def add_child(task)
      children << task unless children.to_a.include? task
      task.parent = self

      self
    end

    def remove_child(task)
      children.delete(task)
      task.parent = nil

      self
    end

    # --- }}}

  end
end
