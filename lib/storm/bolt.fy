class Storm {
  class Bolt : Component {
    """
    Bolts represent the actual work processes that receive tuples and
    emit new @Storm Tuple@s on their output stream (possible consumed by other Bolts).
    """

    class ClassMethods {
      def input: input_fields {
        @input_fields = input_fields to_a
        @input_fields each_with_index: |f i| {
          class_eval: """
          def #{f} { @tuple[#{i}] }
          """
        }
      }

      def ack_on_success: @ack_on_success
      def ack_on_success? {
        @ack_on_success true?
      }

      def anchor_tuples: @anchor_tuples {
        if: anchor_tuples? then: {
          @output_streams each_key: |name| {
            class_eval: """
            def #{name}: tuple_out {
              @streams[#{name inspect}] <- (tuple_out anchor: @tuple)
            }
            """
          }
        }
      }
      def anchor_tuples? {
        @anchor_tuples true?
      }
    }

    extend: ClassMethods

    def process: @tuple {
      try {
        process
        { @tuple ack! } if: ack_on_success?
      } catch {}
    }

    def run {
      """
      Runs the bolt, causing it to receive messages, perform work defined in @Bolt#run
      and possibly emit new messages (@Storm Tuple@s).
      """

      heartbeat_dir = read_string_message
      send_pid: heartbeat_dir
      @conf, @context = read_env
      try {
        loop: {
          process: $ Tuple from_hash: read_message
          sync
        }
      } catch Exception => e {
        log: e
      }
    }
  }

  class BlockBolt : Bolt {
    def initialize: @block
    def --> component {

    }
  }
}