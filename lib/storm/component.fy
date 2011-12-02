class Storm {
  class Component {
    class Config {
      read_write_slots: ('parallelism, 'grouping)
      def fields_grouping: fields on: component_name {
        @grouping = FieldsGrouping new: (fields to_a) component: component_name
      }
    }

    include: Storm Protocol
    read_slots: ('fields, 'streams)

    def Component new: block {
      component_class = self subclass: block
    }

    def initialize {
      @fields = Set new
      @streams = Set new
      @slots = []

      setup_constructor_methods
    }

    def setup_constructor_methods {
      def self new {
        @slots each: |s| {
          set_slot: s value: nil
        }
        self
      }

      def self new: args {
        @slots each_with_index: |s i| {
          set_slot: s value: $ args[i]
        }
        self
      }

      def self new: args with: config_block {
        new: args
        with: config_block
      }
    }

    def fields: block {
      @fields = Set new: $ block to_a
    }

    def slots: block {
      @slots = block to_a
      @slots each: |s| {
        set_slot: s value: nil
      }
    }

    def process: process_block  {
      @process_block = process_block
    }

    def with: config_block {
      @conf = Config new
      config_block call: [@conf]
      self
    }

    def output_streams {
      @output_streams values
    }

    def fields {
      @fields
    }

    def on: stream_name emit: tup anchors: anchors ([]) direct: direct (nil) {
      stream_id = @@output_streams[stream_name] id
      emit: tup stream: stream_id anchors: anchors direct: direct
    }
  }
}