class QueueData
  attr_accessor :queue_name, :size, :consumers, :enqueued, :dequeued

  def initialize(queue_name, size, consumers, enqueued, dequeued)
    self.queue_name = queue_name
    self.size = Integer(size)
    self.consumers = Integer(consumers)
    self.enqueued = Integer(queued)
    self.dequeued = Integer(dequeued)
  end

  def -(last_queue_data)
    raise 'Invalid last_queue_data' unless last_queue_data.is_a?(QueueData)

    self.class.new(
      queue_name,
      size,
      consumers,
      enqueued - last_queue_data.enqueued,
      dequeued - last_queue_data.dequeued
    )
  end
end
