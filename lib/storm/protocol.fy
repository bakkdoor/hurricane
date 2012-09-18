require("rubygems")
require("json")

class Storm {
  class Protocol {
    """
    Storm Protocol class.
    Contains all methods implementing the Storm multilang protocol using STDIO.
    """

    Input = STDIN
    Output = STDOUT

    metaclass read_write_slots: ('pending_taskids, 'pending_commands)

    self pending_taskids:  []
    self pending_commands: []

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

    def read_task_ids {
      Storm Protocol pending_taskids shift || {
        msg = read_message
        until: { msg is_a?: Array } do: {
          Storm Protocol pending_commands << msg
          msg = read_message
        }
        msg
      }
    }

    def read_command {
      Storm Protocol pending_commands shift || {
        msg = read_message
        while: { msg is_a?: Array } do: {
          Storm Protocol pending_taskids << msg
          msg = read_message
        }
        msg
      }
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
      send: <['command => 'sync]>
    }

    def send_pid: heartbeat_dir {
      pid = Process pid()
      send: <['pid => pid]>
      File open(heartbeat_dir ++ "/" ++ pid, "w") close
    }

    def emit_bolt: tuple with: options (<[]>) {
      options = options to_hash
      stream  = options['stream]
      direct  = options['direkt_task]
      anchors = (options['anchors] || options['anchor]) to_a

      match tuple {
        case Storm Tuple -> anchors = anchors + (tuple anchors)
      }

      m = <[
        'command => 'emit,
        'anchors => anchors map: @{ id },
        'tuple => tuple to_a
      ]>

      { m['stream]: stream } if: stream
      { m['task]: direct } if: direct

      send: m

      { read_task_ids } unless: direct
    }

    def emit_spout: tuple with: options (<[]>) {
      options = options to_hash
      stream  = options['stream]
      id      = options['id]
      direct  = options['direct_task]

      m = <['command => 'emit, 'tuple => tuple]>

      { m['id]: id } if: id
      { m['stream]: stream } if: stream
      { m['task]: direct } if: direct

      send: m

      { read_task_ids } unless: direct
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

    def handshake {
      """
      @return @Tuple@ of Storm (config, context).
      """

      setup_info = read_message
      send_pid: $ setup_info["pidDir"]
      (setup_info["conf"], setup_info["context"])
    }
  }
}