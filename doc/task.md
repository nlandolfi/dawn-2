Task
----

* A task represents a small actionable task.
* Tasks have dependencies, other tasks which they rely upon.
* Tasks have a tree nature, as such a task has one parent, and many children.

Core
----

A task belongs to a queue (this relationship is still being developed)

Task#key()
    * Returns the symbolized lowercase name of the task

Dependencies
------------

A task has and belongs to many dependencies. As such a task can be dependended upon by several other tasks and several other tasks can depend upon it.

Task#add_dependency(Dawn::Task task)
    * Adds the task to this task's dependencies

Task#remove_dependency(Dawn::Task task)
    * Removes the task from this task's dependendencies

Task#dependencies?() || Task#has_dependencies?
    * Returns a boolean whether this task has dependencies.

Task#no_dependencies?()
    * Boolean whether this task has no dependencies.

Tree Nature
-----------

A task has many children, and belongs to a parent.

Task#subtasks()
    Returns the task's children

Task#root?() || Task#is_root?() || Task#has_parent?
    True if this task has no parent. False if it has a parent.

Task#child? || Task#is_child?
    Boolean of whether this task is a child of another task. Inverse of Task#root?

Task#parent? || Task#is_parent? || Task#parent?
    Boolean of whether this task has any children






