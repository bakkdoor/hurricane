class Storm {
  class Component {
    """
    Base class for Storm components, including @Storm::Spout@s and @Storm::Bolt@s.
    A component is anything that can send and receive @Storm::Tuple@s via streams in realtime.
    """

    class MissingOutputStreamsError : StandardError

    class ClassMethods {
      read_slot: 'output_streams

      def output: output_fields {
        @output_streams = <[
          'default => stream: (output_fields to_a) name: 'default
        ]>

        define_output_methods
      }

      def outputs: output_streams {
        @output_streams = output_streams to_hash map: |name stream_info| {
          (name, stream: (stream_info to_a) name: name)
        } to_hash

        define_output_methods
      }

      private: {
        def stream: stream_info name: name {
          stream_info = stream_info to_a
          fields = stream_info reject: @{ is_a?: Array }
          options = stream_info - fields to_hash

          OutputStream new: @{
            name:    name
            fields:  fields
            options: options
          }
        }

        def define_output_methods {
          @output_streams each: |name val| {
            class_eval: """
            def #{name}: tuple_out {
              @output_streams[#{name inspect}] <- tuple_out
            }
            """
          }
        }
      }

      def slots: slots {
        @slots = @slots to_a
      }

      def setup: @setup_block

      def do_setup: component {
        if: @setup_block then: @{
          call: [component]
        }
        { MissingOutputStreamsError raise: "No output streams or fields defined in: #{name}!" } unless: @output_streams
      }

      def default_instance {
        { @default_instance = new } unless: @default_instance
        @default_instance
      }

      def * parallelism_hint {
        default_instance parallelism: parallelism_hint
      }

      def parallelism {
        default_instance parallelism
      }

      def [component_name] {
        new: "#{name}:#{component_name}"
      }

      def --> component {
        default_instance --> component
      }

      def -- grouping {
        default_instance -- grouping
      }
    }

    include: Storm Protocol
    extend:  ClassMethods

    read_write_slots: ('parallelism, 'component_name)

    def initialize: @component_name (nil) {
      { @component_name = class name } unless: @component_name
      @parallelism = 1
      Component do_setup: self
      { *storm_topology* add_component: self } if: *storm_topology*
    }

    def output_streams {
      class output_streams
    }

    def --> component {
      # TODO
      component
    }

    def -- grouping {
      # TODO
      self
    }
  }
}