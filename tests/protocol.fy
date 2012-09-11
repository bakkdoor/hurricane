require: "mocks"

FancySpec describe: Storm Protocol with: {
  before_each: {
    Storm Protocol Input clear
    Storm Protocol Output clear
    @storm = Storm Protocol new
    @in = Storm Protocol Input
    @out = Storm Protocol Output
    @tuple = Storm Tuple new: 1 component: 2 stream: 3 task: 4 values: [1,2,3,4]
  }

  it: "reads a string message correctly" for: 'read_string_message when: {
    @in receive_msg: "/tmp/"
    @storm read_string_message is == "/tmp/"
  }

  it: "reads a json message correctly" for: 'read_message when: {
    @in receive_msg: "{\"foo\":123, \"bar\":\"foobar\", \"tuple\":[1,2,\"cool\"]}"
    msg = @storm read_message
    msg is == <["foo" => 123, "bar" => "foobar", "tuple" => [1,2,"cool"]]>
  }

  it: "sends a message correctly" for: 'send: when: {
    msg = <['hello => "world", 'testing => 42]>
    @storm send: msg
    @out sent is == ["#{msg to_json()}\n", "end\n"]
  }

  it: "sends the pid to the parent process" for: 'send_pid: when: {
    @storm send_pid: "/tmp/"
    pid = Process pid()
    cmd = <['pid => pid]>
    @out sent is == ["#{cmd to_json()}\n", "end\n"]
  }

  it: "syncs with the parent process" for: 'sync when: {
    @storm sync
    cmd = <['command => 'sync]>
    @out sent is == ["#{cmd to_json()}\n", "end\n"]
  }

  it: "acks a tuple" for: 'ack: when: {
    @storm ack: @tuple
    ack_msg = JSON parse(@out sent[-2])
    ack_msg is == <["command" => "ack", "id" => @tuple id]>
  }

  it: "fails a tuple" for: 'fail: when: {
    @storm fail: @tuple
    fail_msg = JSON parse(@out sent[-2])
    fail_msg is == <["command" => "fail", "id" => @tuple id]>
  }

  it: "logs a message" for: 'log: when: {
    @storm log: "log test"
    log_msg = JSON parse(@out sent[-2])
    log_msg is == <["command" => "log", "msg" => "log test"]>
  }
}