class Storm {
  class Bolt : Component {
    """
    Bolts represent the actual work processes that receive and emit
    @Storm::Tuple@s on their output stream (possible consumed by other Bolts).
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

      def ack: @always_ack
      def always_ack? {
        @always_ack true?
      }

      def anchor_tuples: @anchor_tuples {
        if: anchor_tuples? then: {
          @output_streams each_key: |name| {
            class_eval: """
            def #{name}: tuple_out {
              @output_streams[#{name inspect}] <- (tuple_out anchor: @tuple)
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

    def prepare: conf context: context

    def emit: tuple with: options (<[]>) {
      emit_bolt: tuple with: options
    }

    def process

    def process: @tuple {
      try {
        process
        { @tuple ack! } if: (class ack_on_success?)
      } finally {
        { @tuple ack! } if: (class always_ack?)
      }
    }

    def run {
      """
      Runs the bolt, causing it to receive messages, perform work defined in @Bolt#run
      and possibly emit new messages (@Storm Tuple@s).
      """

      setup
      conf, context = handshake
      prepare: conf context: context

      try {
        loop: {
          process: $ Tuple from_hash: read_message
        }
      } catch Exception => e {
        msg = e message
        match msg {
          case "EOF" -> nil # ignore
          case _ ->
            bt  = e backtrace join: "\n"
            log: "Exception in bolt #{class name} : #{msg} - #{bt}"
            error_msg = "ERROR: '#{msg}':\n======================\n#{bt}\n======================"
            *stderr* println: error_msg
        }
      }
    }
  }

  class BlockBolt : Bolt {
    """
    A BlockBolt is a @Storm::Bolt@ that calls a Block with each incoming
    @Storm::Tuple@ and outputs the return value to its output stream.
    It auto-anchors outgoing @Storm::Tuple@s to the incoming ones and auto-acks
    any incoming Tuples after calling the Block with them to generate
    the output Tuple.

    Example:
          SumFields = BlockBolt new: @{ sum }
          # or use fields explicitly:
          SumFields = BlockBolt new: |f1 f2 f3| {
            f1 + f2 + f3
          }
    """

    read_slot: 'block
    output: { value }
    anchor_tuples: true

    def initialize: @block

    def output: tuple {
      emit: tuple
    }

    def process: tuple {
      output: $ @block call: (tuple values)
      tuple ack!
    }
  }
}