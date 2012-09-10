class Storm {
  class Component {
    """
    Base class for Storm components, including @Storm::Spout@s and @Storm::Bolt@s.
    A component is anything that can send and receive @Storm::Tuple@s via streams in realtime.
    """

    class ClassMethods {
      def output: output_fields {
        @output_streams = <[
          'default => stream: (output_fields to_a) name: 'default
        ]>
      }

      def outputs: output_streams {
        @output_streams = output_streams to_hash map: |name stream_info| {
          (name, stream: (stream_info to_a) name: name)
        } to_hash
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
      }

      def slots: slots {
        @slots = @slots to_a
      }

      def setup: @setup_block

      def do_setup: component {
        if: @setup_block then: @{
          call: [component]
        }
      }

      def * parallelism_hint {
        @parallelism_hint = parallelism_hint
      }

      def [name] {
        dup tap: @{
          extend: ClassMethods
          component_name: "#{component_name}:#{name}"
        }
      }

      def component_name: @component_name
      def component_name {
        @component_name || name
      }

      def --> component {
        # TODO
        *storm_topology* add_component: self
        *storm_topology* add_component: component
        component
      }

      def -- grouping {
        # TODO
        *storm_topology* add_component: self
        self
      }
    }

    include: Storm Protocol
    extend:  ClassMethods

    read_slots: ('fields, 'streams)

    def initialize {
      @fields = Set new
      @slots = []
      Component do_setup: self
    }
  }
}