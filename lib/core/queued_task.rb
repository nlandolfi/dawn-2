
module Dawn
  class QueuedTask < ActiveRecord::Base

    # --- Core {{{

    belongs_to :task
    belongs_to :queue

    # --- }}}

    # --- Queue {{{

    def current?; self.current; end
    alias_method :is_current?, :current?

    def complete?; self.complete; end
    alias_method :is_complete?, :complete?

    def incomplete; !complete?; end
    alias_method :incomplete?, :incomplete
    alias_method :is_incomplete?, :incomplete

    # --- }}}

  end
end

