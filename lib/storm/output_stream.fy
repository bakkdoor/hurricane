class Storm {
  class OutputStream {
    read_write_slots: ('name, 'options, 'fields)
    def initialize: block {
      block call: [self]
    }
  }
}