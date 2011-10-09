class Storm {
  class Component {
    def Component output_fields: fields {
      @@output_fields = fields
    }
    def Component parallelism: p {
      @@parallelism = p
    }

#    read_write_slots: ('output_fields, 'parallelism)

    def initialize {
      # @parallelism = 1
      # @output_fields = []
    }
  }
}