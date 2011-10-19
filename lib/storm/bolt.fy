class Storm {
  class Bolt : Component {
    """
    Bolts represent the actual work processes that receive tuples and
    emit new @Storm Tuple@s on their output stream (possible consumed by other Bolts).
    """

    def initialize: @conf context: @context {
      super initialize
    }

    def process: tuple

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
}