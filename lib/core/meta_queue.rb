
module Dawn
  class MetaQueue < ActiveRecord::Base

    has_many :queued_queues
    has_many :queues, through: :queued_queues

    def tasks
      tasks = []

      queues.each { |queue| tasks.concat(queue.tasks) }

      tasks
    end

  end
end
