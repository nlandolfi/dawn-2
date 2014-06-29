
module Dawn
  class Task < ActiveRecord::Base

    # --- Core {{{

    belongs_to :queue

    def key
      self.name.downcase.to_sym
    end

    # --- }}}

    # --- Dependencies {{{

    has_and_belongs_to_many :dependencies,
             class_name: "Task",
             join_table: :task_dependencies,
             foreign_key: :task_id,
             association_foreign_key: :dependent_id

    def add_dependency(task)
      dependencies << task
    end

    def remove_dependency(task)
      dependencies.delete(task)
      return dependencies
    end

    def no_dependencies?
      dependencies.empty?
    end

    alias_method :has_no_dependencies?, :no_dependencies?

    def dependencies?; !no_dependencies?; end

    alias_method :has_dependencies?, :dependencies?

    # --- }}}

    # --- Tree Nature {{{

    belongs_to :parent, class_name: "Task", foreign_key: :parent_task_id
    has_many :children, class_name: 'Task', foreign_key: :parent_task_id

    def subtasks; children; end

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

    # --- }}}

  end
end
