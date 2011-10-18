class Storm {
  class Component {
    class OutputStreamDef {
      @@stream_id = 0
      def OutputStreamDef next_id {
        @@stream_id = @@stream_id + 1
        @@stream_id
      }

      read_write_slots: ('fields, 'direct, 'id)

      def initialize {
        @fields = []
        @direct = false
        @id = OutputStreamDef next_id
      }
    }

    class OutputStreamsDef {
      def initialize: @bolt

      def stream: block {
        streamdef = OutputStreamDef new do: block
        @bolt add_stream: streamdef
      }
    }

    @@output_streams = []

    def Component output_streams: block {
      @@output_streams = []
      OutputStreamsDef new: self . do: block
    }

    def Component add_stream: s {
      id = @@output_streams size
      s id: id
      @@output_streams << s
    }

    def Component output_fields: fields {
      @@output_fields = fields
    }

    def Component output_field: field {
      @@output_fields = [field]
    }

    def Component parallelism: p {
      @@parallelism = p
    }

    def Component output_streams {
      @@output_streams
    }

    def Component output_fields {
      @@output_fields
    }

    def output_streams {
      @@output_streams
    }

    def output_fields {
      @@output_fields
    }
  }
}