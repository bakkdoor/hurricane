class Storm {
  class Config {
    read_write_slots: ('max_task_parallelism, 'num_workers)

    def initialize: block {
      do: block
    }
  }
}