class Storm {
  class Component {
    """
    Base class for Storm components, including @Storm::Spout@s and @Storm::Bolt@s.
    A component is anything that can send and receive @Storm::Tuple@s via streams in realtime.
    """

    class Config {
      """
      Component Configuration class.
      Used for topology configuration purposes.
      """

      read_write_slots: ('parallelism, 'grouping)
      def fields_grouping: fields on: component_name {
        @grouping = FieldsGrouping new: (fields to_a) component: component_name
      }
    }

    include: Storm Protocol
    read_slots: ('fields, 'streams)

    def initialize {
      @fields = Set new
      @slots = []
      @initialize_block = {} # does nothing by default

      setup_constructor_methods
    }

    def initialize: @initialize_block

    def setup_streams {
      @streams = <['default => OutputStream new: self name: 'default fields: @fields]>
      setup_stream_accessors
    }

    def setup_constructor_methods {
      def self new: args {
        @slots each_with_index: |s i| {
          set_slot: s value: $ args[i]
        }
        setup_streams
        @initialize_block call_with_receiver: self
        self
      }

      def self new {
        new: []
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

    def streams: block {
      block to_hash each: |name fields| {
        @streams[name]: $ OutputStream new: self name: name fields: fields
      }
    }

    def setup_stream_accessors {
      @streams each: |name stream| {
        define_singleton_method: name with: { stream }
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
      emit: tup stream: stream_name anchors: anchors direct: direct
    }
  }
}