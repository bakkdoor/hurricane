class Storm {
  class Spout : Component {
    def run {
      loop: {
        @process_block call_with_receiver: self
      }
    }
  }
}