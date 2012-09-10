class Storm {
  class OutputStream {
    include: Storm Protocol

    read_write_slots: ('name, 'options, 'fields)
    def initialize: block {
      block call: [self]
    }

    def <- tuple {
      emit: tuple stream: @name
    }
  }
}