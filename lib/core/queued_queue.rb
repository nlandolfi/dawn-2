
module Dawn
  class QueuedQueue < ActiveRecord::Base

    # --- Core {{{

    belongs_to :queue
    belongs_to :meta_queue

    # --- }}}

  end
end

