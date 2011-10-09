class Storm {
  class Component {
    read_write_slots: ('output_fields, 'parallelism)

    def initialize {
      @parallelism = 1
      @output_fields = []
    }
  }
}