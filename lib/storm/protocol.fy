class Storm {
  class Protocol {
    """
    Storm Protocol class.
    Contains all methods implementing the Storm multilang protocol using stdio.
    """

    Input = STDIN
    Output = STDOUT

    def read_string_message {
      """
      @return @String@ message send by the parent Storm process.
      """

      msg = ""
      loop: {
        line = Input readline chomp
        { break } if: (line == "end")
        msg << line
        msg << "\n"
      }
      msg chomp
    }

    def read_message {
      """
      @return @Hash@ that is a JSON parsed message from the parent Storm process.
      """

      JSON parse(read_string_message)
    }

    def send: message {
      """
      @message Message to be sent to the parent Storm process converted to JSON.

      Sends a message as JSON to the parent Storm process.
      """

      Output println: $ message to_json()
      Output println: "end"
      Output flush
    }

    def sync {
      Output println: "sync"
      Output flush
    }

    def send_pid: heartbeat_dir {
      pid = Process pid()
      Output println: pid
      Output flush
      File open(heartbeat_dir ++ "/" ++ pid, "w") close
    }

    def emit_tuple: tup stream: stream (nil) anchors: anchors ([]) direct: direct (nil) {
      m = <['command => 'emit, 'anchors => anchors map: 'id, 'tuple => tup to_a]>
      { m['stream]: stream } if: stream
      { m['task]: direct } if: direct
      send: m
    }

    def emit: tup stream: stream (nil) anchors: anchors ([]) direct: direct (nil) {
      emit_tuple: tup stream: stream anchors: anchors direct: direct
      read_message
    }

    def ack: tuple {
      """
      @tuple @Storm Tuple@ to be acked by Storm.
      """

      send: <['command => 'ack, 'id => tuple id]>
    }

    def fail: tuple {
      """
      @tuple @Storm Tuple@ to be failed by Storm.
      """

      send: <['command => 'fail, 'id => tuple id]>
    }

    def log: message {
      """
      @message Message to be logged by Storm.
      """

      send: <['command => 'log, 'msg => message to_s]>
    }

    def read_env {
      """
      @return @Tuple@ of Storm (config, context).
      """

      (read_message, read_message)
    }
  }
}