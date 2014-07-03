
module Dawn
  class QueuedTask < ActiveRecord::Base

    # --- Core {{{

    belongs_to :task

    # --- }}}

    # --- Queue {{{

    belongs_to :queue

    def current?; self.current; end
    alias_method :is_current?, :current?

    def complete?; self.complete; end
    alias_method :is_complete?, :complete?

    def incomplete; !complete?; end
    alias_method :incomplete?, :incomplete
    alias_method :is_incomplete?, :incomplete

    def complete!
      queue.mark_complete_task(self.task)
    end

    # --- }}}

  end
end

