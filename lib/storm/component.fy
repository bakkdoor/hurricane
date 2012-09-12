class Storm {
  class Component {
    """
    Base class for Storm components, including @Storm::Spout@s and @Storm::Bolt@s.
    A component is anything that can send and receive @Storm::Tuple@s via streams in realtime.
    """

    class MissingOutputStreamsError : StandardError

    class ClassMethods {
      """
      @Storm::Component@ class methods.
      """

      read_slot: 'output_streams

      def output: output_fields {
        """
        @output_fields @Array@ / @Block@ of output field names.

        Example:
              class MyBolt : Storm Bolt {
                output: { field1 field2 field3 }
              }
        """

        @output_streams = <[
          'output => stream: (output_fields to_a) name: 'output
        ]>

        define_output_methods
      }

      def outputs: output_streams {
        """
        @output_streams @Hash@ / @Block@ of stream names to output field names.

        Example:
              class MyBolt : Storm Bolt {
                outputs: {
                  stream1: { field1 field2 }
                  stream2: { field3 field4 }
                }
              }
        """

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
            match name {
              case 'output -> nil # ignore (defined below)
              case _ ->
                class_eval: """
                def #{name}: tuple {
                  emit: tuple with: <['stream => #{name inspect}]>
                }
                """
            }
          }
        }
      }

      def slots: slots {
        """
        @slots @Array@ / @Block@ of slot names to define for a component.
        """

        read_write_slots: $ slots to_a
      }

      def setup: @setup_block {
        """
        @setup_block @Block@ to be used for setting up an instance of @self.
        """
      }

      def do_setup: component {
        """
        @component @Storm::Component@ to setup with a provided setup block, if any defined.

        Raises a @Storm::Component::MissingOutputStreamsError@ if no output streams / fields defined.
        """

        if: @setup_block then: @{
          call: [component]
        }
        { MissingOutputStreamsError raise: "No output streams or fields defined in: #{name}!" } unless: @output_streams
      }

      def default_instance {
        """
        @return Default instance of @self when using non-named components within a topology.
        """

        { @default_instance = new } unless: @default_instance
        @default_instance
      }

      lazy_slot: 'instances value: { <[]> }

      def * parallelism_hint {
        """
        @parallelism_hint Parallelism hint to be used for the default instance of @self.
        """

        default_instance parallelism: parallelism_hint
      }

      def parallelism {
        """
        @return Parallelism hint set for the default instance of @self.
        """

        default_instance parallelism
      }

      def [component_name] {
        """
        @component_name Suffix to use for new component name.
        @return New instance of @self using @component_name as the suffix for its component name.
        """

        key = "#{name}:#{component_name}"
        instances at: key else_put: { new: key }
      }

      def --> component {
        """
        @component @Storm::Component@ to setup a @Storm::NoneGrouping@ (subscription) for with the default instance.

        Forwards to:
              default_instance --> component
        """

        default_instance --> component
      }

      def -- grouping {
        """
        @grouping @Storm::Grouping@ to setup for the default instance as the sender.
        @return @grouping.

        Forwards to:
              default_instance -- grouping
        """

        default_instance -- grouping
      }
    }

    include: Storm Protocol
    extend:  ClassMethods

    read_write_slots: ('parallelism, 'component_name)

    def initialize: @component_name (nil) {
      { @component_name = class name } unless: @component_name
      @parallelism = 1
      { *storm_topology* add_component: self } if: *storm_topology*
      setup
    }

    def setup {
      """
      Sets up @self based on any setup @Block@ defined for this component's class.
      """

      class do_setup: self
    }

    def output_streams {
      """
      @return @Hash@ of stream name to @Storm::OutputStream@ defined for @self.
      """

      class output_streams dup
    }

    def groupings {
      """
      @return @Array@ of @Storm::Grouping@s defined for @self.
      """

      Grouping[self] dup
    }

    def --> component {
      """
      @component @Storm::Component@ to setup a @Storm::NoneGrouping@ (subscription) for with @self.
      """

      Grouping[self] << (NoneGrouping new: self to: component)
      component
    }

    def -- grouping {
      """
      @grouping @Storm::Grouping@ to setup for @self as the sender.
      @return @grouping.
      """

      grouping = Grouping parse: grouping sender: self
      Grouping[self] << grouping
      grouping
    }

    def output: tuple {
      """
      @tuple @Storm::Tuple@ to be emitted from @self on the default output stream.
      """

      emit: tuple
    }
  }
}