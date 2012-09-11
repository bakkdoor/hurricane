class Storm {
  class Spout : Component {
    def open: conf context: context

    def next_tuple

    def ack: id

    def fail: id

    def run {
      conf, context = handshake
      open: conf context: context

      try {
        loop: {
          msg = read_message
          match msg["command"] {
            case "next" -> next_tuple
            case "ack" -> ack: $ msg["id"]
            case "fail" -> fail: $ msg["id"]
          }
          sync
        }
      } catch Exception => e {
        msg = e message
        bt  = e backtrace join: "\n"
        log: "Exception in spout #{class name} : #{msg} - #{bt}"

        error_msg = "ERROR: '#{msg}':\n======================\n#{bt}\n======================"
        *stderr* println: error_msg
      }
    }
  }
}